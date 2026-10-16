import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../../core/tracking/tracked_point.dart';
import '../../../core/tracking/tracking_session.dart';
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
  final _replaced = StreamController<void>.broadcast();
  StreamSubscription<Map<String, dynamic>?>? _fixSub;
  StreamSubscription<Map<String, dynamic>?>? _overSub;
  StreamSubscription<Map<String, dynamic>?>? _replacedSub;

  @override
  Stream<TrackedPoint> get fixes => _fixes.stream;

  @override
  Stream<void> get tripOver => _over.stream;

  @override
  Stream<void> get sessionReplaced => _replaced.stream;

  @override
  Future<TrackingSession> start(String tripId, TrackingSession session) async {
    const storage = TrackingService.storage;
    final stored = await storage.read(key: TrackingService.tripIdKey);
    var running = await _service.isRunning();
    if (running && stored != tripId) {
      // Another trip's service (the app was killed mid-trip earlier).
      _service.invoke(TrackingService.stopEvent);
      await _waitUntilStopped();
      running = false;
    }
    var effective = session;
    if (running) {
      // The service kept tracking this trip while the app was gone: it keeps
      // its session (its points would otherwise look like a stranger's).
      final id = await storage.read(key: TrackingService.sessionIdKey);
      final device = await storage.read(key: TrackingService.deviceIdKey);
      if (id != null && id.isNotEmpty && device != null) {
        effective = TrackingSession(
            sessionId: id,
            deviceId: device,
            claimed: await storage.read(key: TrackingService.sessionClaimedKey) == '1');
      }
    } else {
      await storage.write(key: TrackingService.sessionIdKey, value: session.sessionId);
      await storage.write(key: TrackingService.deviceIdKey, value: session.deviceId);
      await storage.delete(key: TrackingService.sessionClaimedKey);
    }
    await storage.write(key: TrackingService.tripIdKey, value: tripId);
    _listen();
    if (!running) await _service.startService();
    return effective;
  }

  @override
  Future<void> stop() async {
    await _fixSub?.cancel();
    await _overSub?.cancel();
    await _replacedSub?.cancel();
    _fixSub = _overSub = _replacedSub = null;
    _service.invoke(TrackingService.stopEvent);
    const storage = TrackingService.storage;
    await storage.delete(key: TrackingService.tripIdKey);
    await storage.delete(key: TrackingService.sessionIdKey);
    await storage.delete(key: TrackingService.deviceIdKey);
    await storage.delete(key: TrackingService.sessionClaimedKey);
  }

  @override
  Future<void> dispose() async {
    await _fixSub?.cancel();
    await _overSub?.cancel();
    await _replacedSub?.cancel();
    await _fixes.close();
    await _over.close();
    await _replaced.close();
  }

  void _listen() {
    _fixSub?.cancel();
    _overSub?.cancel();
    _replacedSub?.cancel();
    _replacedSub = _service.on(TrackingService.sessionReplacedEvent).listen((_) {
      debugPrint('[Tracking] service reports the trip moved to another device');
      _replaced.add(null);
    });
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
