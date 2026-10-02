import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_errors.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/sync/sync_queue.dart';
import 'active_trip_store.dart';

enum TrackingStartResult {
  started,
  alreadyRunning,
  locationServiceOff,
  permissionDenied,
  permissionDeniedForever,
}

/// Thrown by [TripTrackingNotifier.endTrip] when pickups/drops are still
/// waiting to sync — ending the trip first would lose them on the server.
class PendingSyncException implements Exception {
  final int pending;
  PendingSyncException(this.pending);
  @override
  String toString() =>
      '$pending pickup/drop update${pending == 1 ? '' : 's'} not synced yet. '
      'Connect to the internet, wait for sync, then end the trip.';
}

/// Thrown by [TripTrackingNotifier.endTrip] when the backend refuses to end
/// a drop trip because kids are still marked as picked (409
/// KIDS_NOT_DROPPED). [kids] = [{kidId, fullname}].
class KidsNotDroppedException implements Exception {
  final List<Map<String, dynamic>> kids;
  final String message;
  KidsNotDroppedException(this.kids, this.message);
  @override
  String toString() => message;
}

@immutable
class TripTrackingState {
  final Map<String, dynamic>? trip;
  final bool isTracking;
  final bool socketConnected;
  final LatLng? lastPosition;

  /// Metres per second from the GPS fix (null if the device doesn't report
  /// it). Kept for upcoming overspeed monitoring.
  final double? lastSpeed;

  const TripTrackingState({
    this.trip,
    this.isTracking = false,
    this.socketConnected = false,
    this.lastPosition,
    this.lastSpeed,
  });

  String? get tripId => tripIdOf(trip);

  static String? tripIdOf(Map<String, dynamic>? trip) {
    final id = trip?['_id'] ?? trip?['id'];
    return id?.toString();
  }

  TripTrackingState copyWith({
    Map<String, dynamic>? trip,
    bool? isTracking,
    bool? socketConnected,
    LatLng? lastPosition,
    double? lastSpeed,
  }) {
    return TripTrackingState(
      trip: trip ?? this.trip,
      isTracking: isTracking ?? this.isTracking,
      socketConnected: socketConnected ?? this.socketConnected,
      lastPosition: lastPosition ?? this.lastPosition,
      lastSpeed: lastSpeed ?? this.lastSpeed,
    );
  }
}

final tripTrackingProvider =
    NotifierProvider<TripTrackingNotifier, TripTrackingState>(
        TripTrackingNotifier.new);

/// Owns everything that must keep running for the whole trip — GPS stream,
/// Android foreground service, Socket.IO connection — independent of which
/// screen is open. Previously all of this lived inside TripScreen and died
/// whenever that screen was disposed.
class TripTrackingNotifier extends Notifier<TripTrackingState> {
  final loc.Location _location = loc.Location();
  io.Socket? _socket;
  StreamSubscription<loc.LocationData>? _positionSub;
  DateTime? _lastHttpUpdate;

  /// The HTTP endpoint drives geofence push alerts; the socket drives the
  /// live map. The socket gets every fix, HTTP at most this often.
  static const _httpInterval = Duration(seconds: 5);

  @override
  TripTrackingState build() {
    ref.onDispose(_teardown);
    return const TripTrackingState();
  }

  /// Starts (or continues) tracking [trip]. Safe to call repeatedly — if the
  /// same trip is already being tracked it only refreshes the trip details.
  Future<TrackingStartResult> start(Map<String, dynamic> trip) async {
    final id = TripTrackingState.tripIdOf(trip);
    if (id == null || id == 'null') return TrackingStartResult.permissionDenied;

    if (state.isTracking && state.tripId == id) {
      final merged = {...?state.trip, ...trip};
      state = state.copyWith(trip: merged);
      await ActiveTripStore.save(merged);
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
    await ActiveTripStore.save(trip);
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

  /// Stops tracking without touching the trip on the server.
  Future<void> stop() async {
    await _teardown();
    await ActiveTripStore.clear();
    state = const TripTrackingState();
  }

  /// Ends the trip on the server, but only after every queued pickup/drop
  /// has been delivered. Throws [PendingSyncException] if that's not
  /// possible right now, or the API error if /trips/endTrip fails.
  ///
  /// [forceEnd] + [confirmationNote]: end a drop trip even though kids are
  /// still marked as picked (the driver confirmed they checked the van).
  /// Throws [KidsNotDroppedException] when the server refuses.
  Future<void> endTrip({bool forceEnd = false, String? confirmationNote}) async {
    final id = state.tripId;
    if (id == null) {
      await stop();
      return;
    }
    final synced = await SyncQueue.instance.flush();
    if (!synced) throw PendingSyncException(SyncQueue.instance.pending.value);

    final position = state.lastPosition;
    try {
      await ApiService.post('/trips/endTrip', {
        'tripId': id,
        if (position != null) 'lat': position.latitude,
        if (position != null) 'long': position.longitude,
        if (forceEnd) 'forceEnd': true,
        if (forceEnd) 'confirmationNote': confirmationNote ?? '',
      });
    } on DioException catch (e) {
      if (ApiErrors.code(e) == 'KIDS_NOT_DROPPED') {
        final data = e.response?.data;
        final rawKids = data is Map ? data['kids'] : null;
        final kids = rawKids is List
            ? rawKids.whereType<Map>().map((k) => Map<String, dynamic>.from(k)).toList()
            : <Map<String, dynamic>>[];
        throw KidsNotDroppedException(kids, ApiErrors.message(e));
      }
      rethrow;
    }
    await stop();
  }

  /// Best available current position: the last streamed fix, otherwise a
  /// fresh one-shot read. Null if GPS is genuinely unavailable.
  Future<LatLng?> currentPosition() async {
    final last = state.lastPosition;
    if (last != null) return last;
    try {
      final fix = await _location
          .getLocation()
          .timeout(const Duration(seconds: 8));
      if (fix.latitude != null && fix.longitude != null) {
        return LatLng(fix.latitude!, fix.longitude!);
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

    state = state.copyWith(lastPosition: LatLng(lat, lng), lastSpeed: fix.speed);

    if (_socket?.connected == true) {
      _socket!.emit('updateLocation', {
        'tripId': id,
        'location': {'lat': lat, 'long': lng},
      });
    }

    final now = DateTime.now();
    if (_lastHttpUpdate == null || now.difference(_lastHttpUpdate!) >= _httpInterval) {
      _lastHttpUpdate = now;
      SyncQueue.instance
          .submit(
            kind: SyncKind.location,
            path: '/trips/updateLocation/$id',
            body: {
              'lat': lat,
              'lng': lng,
              // m/s — the server records overspeed events from it.
              if (fix.speed != null && fix.speed! >= 0) 'speed': fix.speed,
            },
            tripId: id,
          )
          .catchError((Object e) {
        // The trip was ended elsewhere (admin panel / another device):
        // stop GPS + foreground service instead of tracking forever.
        if (ApiErrors.code(e) == 'TRIP_NOT_ONGOING') {
          debugPrint('[Tracking] server says trip is over — stopping');
          stop();
          return SubmitOutcome.sent;
        }
        // Otherwise non-fatal — live map still works via the socket.
        debugPrint('[Tracking] updateLocation rejected: $e');
        return SubmitOutcome.queued;
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
    final token = await TokenStorage.read() ?? '';
    _socket?.dispose();
    final socket = io.io(
      AppConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
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
      SyncQueue.instance.flush();
    });
    socket.onDisconnect((_) => state = state.copyWith(socketConnected: false));
    socket.onConnectError((e) => debugPrint('[Tracking] socket connect error: $e'));
    socket.connect();
    _socket = socket;
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
