import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import '../../../core/network/api_client.dart';
import '../../../core/tracking/location_buffer.dart';
import '../../../core/tracking/tracked_point.dart';
import '../../../core/tracking/tracking_engine.dart';
import '../../../core/tracking/tracking_uploader.dart';
import 'tracking_backend.dart';

/// Opens the offline point buffer (Hive); a parameter so tests need no disk.
typedef LocationBufferOpener = Future<LocationBuffer> Function();

/// Tracking inside the app's own isolate: GPS from the `location` plugin,
/// uploads and buffering by a [TrackingEngine]. Used on iOS (the location
/// background mode keeps the app running with the screen off) and wherever
/// there is no Android service.
class InAppTrackingBackend implements TrackingBackend {
  InAppTrackingBackend({
    required loc.Location location,
    required ApiClient api,
    required LocationBufferOpener openBuffer,
    DateTime Function()? clock,
  })  : _location = location,
        _api = api,
        _openBuffer = openBuffer,
        _clock = clock ?? DateTime.now;

  /// A fix about every 2 s once the van moved 3 m, so the parents' map
  /// follows smoothly.
  static const gpsIntervalMs = 2000;
  static const gpsDistanceFilterMeters = 3.0;

  final loc.Location _location;
  final ApiClient _api;
  final LocationBufferOpener _openBuffer;
  final DateTime Function() _clock;

  final _fixes = StreamController<TrackedPoint>.broadcast();
  final _over = StreamController<void>.broadcast();
  TrackingEngine? _engine;

  @override
  Stream<TrackedPoint> get fixes => _fixes.stream;

  @override
  Stream<void> get tripOver => _over.stream;

  @override
  Future<void> start(String tripId) async {
    await stop();
    await _enableBackgroundMode();
    await _location.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      interval: gpsIntervalMs,
      distanceFilter: gpsDistanceFilterMeters, // quiet while stationary
    );
    final uploader = TrackingUploader(
      tripId: tripId,
      api: _api,
      buffer: await _openBuffer(),
      clock: _clock,
      onTripOver: () => _over.add(null),
    );
    final engine = TrackingEngine(
      positions: _location.onLocationChanged
          .where((f) => f.latitude != null && f.longitude != null)
          .map(_toPoint),
      sink: uploader,
      clock: _clock,
      seed: () async => _toPoint(
          await _location.getLocation().timeout(const Duration(seconds: 8))),
      onFix: _fixes.add,
    );
    _engine = engine;
    await engine.start();
  }

  @override
  Future<void> stop() async {
    final engine = _engine;
    _engine = null;
    await engine?.stop();
    if (engine != null) {
      try {
        await _location.enableBackgroundMode(enable: false);
      } catch (_) {}
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _fixes.close();
    await _over.close();
  }

  TrackedPoint _toPoint(loc.LocationData fix) => TrackedPoint(
        lat: fix.latitude!,
        lng: fix.longitude!,
        time: fix.time == null
            ? _clock()
            : DateTime.fromMillisecondsSinceEpoch(fix.time!.toInt()),
        speed: fix.speed,
        heading: fix.heading,
        accuracy: fix.accuracy,
      );

  /// Foreground service with a persistent notification, so the GPS stream
  /// survives screen lock / switching apps during the trip (iOS: the location
  /// background mode).
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
}
