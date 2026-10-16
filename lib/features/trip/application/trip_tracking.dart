import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/config/app_config.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_store.dart';
import '../../../core/tracking/gps_signal.dart';
import '../../../core/tracking/tracked_point.dart';
import '../../../core/tracking/tracking_session.dart';
import '../../../core/tracking/tracking_uploader.dart';
import '../../passengers/data/models/kid_absence_event.dart';
import '../data/active_trip_store.dart';
import '../data/models/active_trip.dart';
import '../data/models/geo_point.dart';
import '../data/trip_repository.dart';
import 'always_location.dart';
import 'kid_absence_events.dart';
import 'tracking_backend.dart';
import 'tracking_replaced.dart';
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
  StreamSubscription<TrackedPoint>? _fixSub;
  StreamSubscription<void>? _overSub;
  StreamSubscription<void>? _replacedSub;
  TrackingSession? _session;
  Timer? _signalTimer;
  DateTime? _trackingStartedAt;
  DateTime? _lastRealFixAt;
  double? _lastAccuracy;

  /// How often the GPS signal is re-judged (a dead GPS sends no fixes to
  /// trigger it).
  static const signalCheckEvery = Duration(seconds: 5);

  /// Captured in [build] so teardown never has to read a provider.
  late loc.Location _location;
  late TrackingBackend _backend;

  @override
  TripTrackingState build() {
    _location = ref.read(locationServiceProvider);
    _backend = ref.read(trackingBackendProvider);
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

    ref.read(trackingReplacedProvider.notifier).state = false;
    state = TripTrackingState(
        trip: trip,
        isTracking: true,
        backgroundLocationLimited: !await _hasAlwaysLocation());
    await ref.read(activeTripStoreProvider).save(trip);
    // This phone takes the trip over: any other phone tracking it as this
    // driver is told to stop. Best effort — if it fails now the uploader
    // claims on its first successful request, and until then no ids are sent.
    var requested = TrackingSession.create(await ref.read(deviceIdProvider)());
    try {
      await ref.read(tripRepositoryProvider).claimTrackingSession(id, requested);
      requested = requested.asClaimed;
    } catch (e) {
      debugPrint('[Tracking] could not claim the trip yet: $e');
    }
    _session = requested;
    await _connectSocket(id);

    // The backend finds the van, uploads (live, and later from its buffer)
    // and repeats the last position while it stands still. Here the points
    // only go to the screen and the live socket relay.
    await _fixSub?.cancel();
    await _overSub?.cancel();
    await _replacedSub?.cancel();
    _replacedSub = _backend.sessionReplaced.listen((_) => _onSessionReplaced());
    _fixSub = _backend.fixes.listen(_onFix);
    _overSub = _backend.tripOver.listen((_) {
      // The trip was ended elsewhere (admin panel / another device): stop GPS
      // instead of tracking forever.
      debugPrint('[Tracking] server says trip is over — stopping');
      stop();
    });
    // The session the backend really tracks under (a service that kept
    // running keeps its own); the live socket must use the same one.
    _session = await _backend.start(id, requested);
    _trackingStartedAt = ref.read(clockProvider)();
    _lastRealFixAt = null;
    _lastAccuracy = null;
    _signalTimer?.cancel();
    _signalTimer = Timer.periodic(signalCheckEvery, (_) => checkGpsSignal());
    return TrackingStartResult.started;
  }

  /// Newer values win; what [update] does not know stays as it was.
  ActiveTrip _merge(ActiveTrip? old, ActiveTrip update) => old == null
      ? update
      : update.copyWith(
          routeId: update.routeId ?? old.routeId,
          routeTitle: update.routeTitle ?? old.routeTitle,
          name: update.name ?? old.name,
          startTime: update.startTime ?? old.startTime,
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

  /// A point from the backend: the screen and the live socket relay (every
  /// 2 s while moving; uploads to the server are the backend's business).
  void _onFix(TrackedPoint point) {
    final id = state.tripId;
    if (id == null) return;
    final position = GeoPoint(lat: point.lat, lng: point.lng);
    if (!point.synthetic) {
      _lastRealFixAt = ref.read(clockProvider)();
      _lastAccuracy = point.accuracy;
    }
    state = state.copyWith(lastPosition: position, lastSpeed: point.speed);
    checkGpsSignal();
    if (_socket?.connected == true) {
      _socket!.emit(
          'updateLocation',
          TripRepository.socketLocationPayload(
            id,
            position,
            speedMetersPerSecond: point.speed,
            heading: point.heading,
            accuracy: point.accuracy,
            // Only a session the server knows; an unclaimed id would look
            // like a stranger's to it.
            session: _session?.claimed == true ? _session!.fields : null,
          ));
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
    // socket_io_client 2.x reports a rejected handshake (bad token) as
    // `error`, not `connect_error`.
    socket.on('error', (e) {
      debugPrint('[Tracking] socket error: $e');
      if (e is Map && e['code'] == TrackingUploader.sessionReplacedCode) {
        _onSessionReplaced();
      }
    });
    // The server tells the trip room when a phone took the trip over; the
    // one that lost it stops.
    socket.on('trackingSessionReplaced', (data) {
      if (data is Map && data['replacedSessionId'] == _session?.sessionId) {
        _onSessionReplaced();
      }
    });
    socket.connect();
    _socket = socket;
  }

  /// The trip is tracked from another phone now (the driver continued it
  /// there): stop here and let the driver know.
  Future<void> _onSessionReplaced() async {
    if (!state.isTracking) return;
    debugPrint('[Tracking] trip continued on another device — stopping');
    ref.read(trackingReplacedProvider.notifier).state = true;
    await stop();
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

  /// iOS: is location "Always"? Asks once; false means tracking may end
  /// early in the background (the screen says so). Always true elsewhere.
  Future<bool> _hasAlwaysLocation() async {
    try {
      final always = ref.read(alwaysLocationProvider);
      if (!always.applies) return true;
      return await always.isGranted() || await always.askOnce();
    } catch (e) {
      debugPrint('[Tracking] always-location check failed: $e');
      return true;
    }
  }

  /// Judges the GPS signal now and updates [TripTrackingState.gpsWeak].
  @visibleForTesting
  void checkGpsSignal() {
    if (!state.isTracking) return;
    final weak = isGpsWeak(
      now: ref.read(clockProvider)(),
      lastRealFixAt: _lastRealFixAt,
      trackingStartedAt: _trackingStartedAt,
      accuracy: _lastAccuracy,
      lastSpeed: state.lastSpeed,
    );
    if (weak != state.gpsWeak) state = state.copyWith(gpsWeak: weak);
  }

  Future<void> _teardown() async {
    _signalTimer?.cancel();
    _signalTimer = null;
    await _fixSub?.cancel();
    _fixSub = null;
    await _overSub?.cancel();
    _overSub = null;
    await _replacedSub?.cancel();
    _replacedSub = null;
    _session = null;
    await _backend.stop();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
