import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/config/app_config.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_store.dart';
import '../../passengers/data/models/kid_absence_event.dart';
import '../data/active_trip_store.dart';
import '../data/models/active_trip.dart';
import '../data/kids_not_dropped_error.dart';
import '../data/models/geo_point.dart';
import '../data/trip_repository.dart';
import 'kid_absence_events.dart';
import 'tracking_state.dart';

part 'trip_tracking.g.dart';

enum TrackingStartResult {
  started,
  alreadyRunning,
  locationServiceOff,
  permissionDenied,
  permissionDeniedForever,
}

/// Thrown by [TripTracking.endTrip] when pickups/drops are still waiting to
/// sync — ending the trip first would lose them on the server.
class PendingSyncException implements Exception {
  PendingSyncException(this.pending);

  final int pending;
}

/// Owns everything that must keep running for the whole trip — GPS stream,
/// Android foreground service, Socket.IO connection — independent of which
/// screen is open.
@Riverpod(keepAlive: true)
class TripTracking extends _$TripTracking {
  io.Socket? _socket;
  StreamSubscription<loc.LocationData>? _positionSub;
  DateTime? _lastHttpUpdate;

  /// The HTTP endpoint drives geofence push alerts; the socket drives the
  /// live map. The socket gets every fix, HTTP at most this often.
  static const httpInterval = Duration(seconds: 5);

  /// Captured in [build] so teardown never has to read a provider.
  late loc.Location _location;

  @override
  TripTrackingState build() {
    _location = ref.read(locationServiceProvider);
    ref.onDispose(_teardown);
    return const TripTrackingState();
  }

  /// Starts (or continues) tracking [trip]. Safe to call repeatedly — if the
  /// same trip is already being tracked it only refreshes the trip details.
  Future<TrackingStartResult> start(ActiveTrip trip) async {
    final id = trip.id;
    if (id.isEmpty || id == 'null') return TrackingStartResult.permissionDenied;

    if (state.isTracking && state.tripId == id) {
      final merged = _merge(state.trip, trip);
      state = state.copyWith(trip: merged);
      await ref.read(activeTripStoreProvider).save(merged);
      return TrackingStartResult.alreadyRunning;
    }
    if (state.isTracking) await _teardown();

    final permission = await _ensurePermission();
    if (permission != TrackingStartResult.started) {
      // Still remember the trip so screens can show it, just not tracking.
      state = TripTrackingState(trip: trip);
      return permission;
    }

    state = TripTrackingState(trip: trip, isTracking: true);
    await ref.read(activeTripStoreProvider).save(trip);
    await _connectSocket(id);
    await _enableBackgroundMode();

    await _location.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 10, // metres — avoids flooding updates while stationary
    );
    await _positionSub?.cancel();
    _positionSub = _location.onLocationChanged.listen(
      _onLocation,
      onError: (Object e) => debugPrint('[Tracking] location stream error: $e'),
    );
    return TrackingStartResult.started;
  }

  /// Newer values win; what [update] does not know stays as it was.
  ActiveTrip _merge(ActiveTrip? old, ActiveTrip update) => old == null
      ? update
      : update.copyWith(
          routeId: update.routeId ?? old.routeId,
          routeTitle: update.routeTitle ?? old.routeTitle,
          name: update.name ?? old.name,
        );

  /// Stops tracking without touching the trip on the server.
  Future<void> stop() async {
    await _teardown();
    await ref.read(activeTripStoreProvider).clear();
    state = const TripTrackingState();
  }

  /// Ends the trip on the server, but only after every queued pickup/drop
  /// has been delivered. Throws [PendingSyncException] if that's not
  /// possible right now, or the `AppException` if the end-trip call fails —
  /// for 409 `KIDS_NOT_DROPPED` an `ApiError` whose `kidsNotDropped` lists
  /// the kids.
  ///
  /// [forceEnd] + [confirmationNote]: end a drop trip even though kids are
  /// still marked as picked (the driver confirmed they checked the van).
  Future<void> endTrip(
      {bool forceEnd = false, String? confirmationNote}) async {
    final id = state.tripId;
    if (id == null) {
      await stop();
      return;
    }
    final queue = ref.read(syncQueueProvider);
    final synced = await queue.flush();
    if (!synced) throw PendingSyncException(queue.pending.value);

    await ref.read(tripRepositoryProvider).endTrip(
          tripId: id,
          position: state.lastPosition,
          forceEnd: forceEnd,
          confirmationNote: confirmationNote,
        );
    await stop();
  }

  /// Best available current position: the last streamed fix, otherwise a
  /// fresh one-shot read. Null if GPS is genuinely unavailable.
  Future<GeoPoint?> currentPosition() async {
    final last = state.lastPosition;
    if (last != null) return last;
    try {
      final fix =
          await _location.getLocation().timeout(const Duration(seconds: 8));
      if (fix.latitude != null && fix.longitude != null) {
        return GeoPoint(lat: fix.latitude!, lng: fix.longitude!);
      }
    } catch (e) {
      debugPrint('[Tracking] one-shot location failed: $e');
    }
    return null;
  }

  void _onLocation(loc.LocationData fix) {
    final lat = fix.latitude;
    final lng = fix.longitude;
    final id = state.tripId;
    if (lat == null || lng == null || id == null) return;

    final point = GeoPoint(lat: lat, lng: lng);
    state = state.copyWith(lastPosition: point, lastSpeed: fix.speed);

    if (_socket?.connected == true) {
      _socket!.emit(
          'updateLocation', TripRepository.socketLocationPayload(id, point));
    }

    final now = ref.read(clockProvider)();
    if (_lastHttpUpdate == null ||
        now.difference(_lastHttpUpdate!) >= httpInterval) {
      _lastHttpUpdate = now;
      ref
          .read(tripRepositoryProvider)
          .sendLocation(
            tripId: id,
            position: point,
            // m/s — the server records overspeed events from it.
            speedMetersPerSecond: fix.speed,
          )
          .then((_) {}, onError: (Object e) {
        // The trip was ended elsewhere (admin panel / another device):
        // stop GPS + foreground service instead of tracking forever.
        if (e is ApiError && e.code == TripErrorCodes.tripNotOngoing) {
          debugPrint('[Tracking] server says trip is over — stopping');
          stop();
          return;
        }
        // Otherwise non-fatal — live map still works via the socket.
        debugPrint('[Tracking] updateLocation rejected: $e');
      });
    }
  }

  Future<TrackingStartResult> _ensurePermission() async {
    try {
      var serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return TrackingStartResult.locationServiceOff;
      }
      var permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }
      if (permission == loc.PermissionStatus.deniedForever) {
        return TrackingStartResult.permissionDeniedForever;
      }
      if (permission != loc.PermissionStatus.granted &&
          permission != loc.PermissionStatus.grantedLimited) {
        return TrackingStartResult.permissionDenied;
      }
      return TrackingStartResult.started;
    } catch (e) {
      debugPrint('[Tracking] permission check failed: $e');
      return TrackingStartResult.permissionDenied;
    }
  }

  /// Android foreground service with a persistent notification, so the
  /// GPS stream survives screen lock / switching apps during the trip.
  Future<void> _enableBackgroundMode() async {
    try {
      await _location.changeNotificationOptions(
        title: 'SmartVan — Trip in progress',
        subtitle: 'Sharing your location with parents and school',
        onTapBringToFront: true,
      );
      await _location.enableBackgroundMode(enable: true);
    } catch (e) {
      // Some OEM builds refuse this even with permission; foreground
      // tracking still works.
      debugPrint('[Tracking] enableBackgroundMode failed: $e');
    }
  }

  Future<void> _connectSocket(String tripId) async {
    _socket?.dispose();
    final tokens = ref.read(tokenStorageProvider);
    final socket = ref.read(socketFactoryProvider)(
      ref.read(appConfigProvider).socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          // Asked for on every connect and reconnect (see chat events).
          .setAuthFn((callback) async {
            callback({'token': await tokens.read() ?? ''});
          })
          .enableReconnection()
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .disableAutoConnect()
          .build(),
    );
    socket.onConnect((_) {
      state = state.copyWith(socketConnected: true);
      // Re-join the trip room on every (re)connect.
      socket.emit('startTrip', {'tripId': tripId});
      ref.read(syncQueueProvider).flush();
    });
    socket.onDisconnect((_) => state = state.copyWith(socketConnected: false));
    socket.on('kidAbsence', (data) => _onAbsence(data, cancelled: false));
    socket.on(
        'kidAbsenceCancelled', (data) => _onAbsence(data, cancelled: true));
    socket.onConnectError(
        (e) => debugPrint('[Tracking] socket connect error: $e'));
    socket.connect();
    _socket = socket;
  }

  /// A parent marked (or un-marked) a kid absent for today while the trip is
  /// running.
  void _onAbsence(dynamic data, {required bool cancelled}) {
    if (data is! Map) return;
    ref.read(kidAbsenceBusProvider).add(
          KidAbsenceEvent.fromJson(Map<String, dynamic>.from(data))
              .copyWith(cancelled: cancelled),
        );
  }

  Future<void> _teardown() async {
    await _positionSub?.cancel();
    _positionSub = null;
    _lastHttpUpdate = null;
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    try {
      await _location.enableBackgroundMode(enable: false);
    } catch (_) {}
  }
}
