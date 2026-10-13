import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../../core/tracking/tracked_point.dart';
import '../background/tracking_service.dart';
import 'tracking_backend.dart';

/// Android: the trip is tracked by [TrackingService], a foreground service in
/// its own isolate — so uploads continue when the app is swiped away. This
/// class only starts and stops it and passes its points on.
class ServiceTrackingBackend implements TrackingBackend {
  ServiceTrackingBackend({FlutterBackgroundService? service})
      : _service = service ?? FlutterBackgroundService();

  final FlutterBackgroundService _service;
  final _fixes = StreamController<TrackedPoint>.broadcast();
  final _over = StreamController<void>.broadcast();
  StreamSubscription<Map<String, dynamic>?>? _fixSub;
  StreamSubscription<Map<String, dynamic>?>? _overSub;

  @override
  Stream<TrackedPoint> get fixes => _fixes.stream;

  @override
  Stream<void> get tripOver => _over.stream;

  @override
  Future<void> start(String tripId) async {
    final stored =
        await TrackingService.storage.read(key: TrackingService.tripIdKey);
    final running = await _service.isRunning();
    if (running && stored != tripId) {
      // Another trip's service (the app was killed mid-trip earlier).
      _service.invoke(TrackingService.stopEvent);
      await _waitUntilStopped();
    }
    await TrackingService.storage
        .write(key: TrackingService.tripIdKey, value: tripId);
    _listen();
    if (!await _service.isRunning()) await _service.startService();
  }

  @override
  Future<void> stop() async {
    await _fixSub?.cancel();
    await _overSub?.cancel();
    _fixSub = _overSub = null;
    _service.invoke(TrackingService.stopEvent);
    await TrackingService.storage.delete(key: TrackingService.tripIdKey);
  }

  @override
  Future<void> dispose() async {
    await _fixSub?.cancel();
    await _overSub?.cancel();
    await _fixes.close();
    await _over.close();
  }

  void _listen() {
    _fixSub?.cancel();
    _overSub?.cancel();
    _fixSub = _service.on(TrackingService.fixEvent).listen((data) {
      final point = TrackedPoint.fromMap(data);
      if (point != null) _fixes.add(point);
    });
    _overSub = _service.on(TrackingService.tripOverEvent).listen((_) {
      debugPrint('[Tracking] service reports the trip is over');
      _over.add(null);
    });
  }

  Future<void> _waitUntilStopped() async {
    for (var i = 0; i < 20 && await _service.isRunning(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }
}
