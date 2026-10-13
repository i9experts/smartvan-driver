import 'dart:async';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';
import 'package:smartvan_driver/features/trip/application/tracking_backend.dart';

/// A [TrackingBackend] the test drives: push points with [emit], end the trip
/// from the server's side with [serverEndsTrip].
class FakeTrackingBackend implements TrackingBackend {
  final _fixes = StreamController<TrackedPoint>.broadcast();
  final _over = StreamController<void>.broadcast();
  final List<String> started = [];
  int stops = 0;

  @override
  Stream<TrackedPoint> get fixes => _fixes.stream;

  @override
  Stream<void> get tripOver => _over.stream;

  bool get hasListeners => _fixes.hasListener || _over.hasListener;

  /// A point as the backend would report it (speed in m/s).
  void emit(double lat, double lng,
          {double? speed,
          double? heading,
          double? accuracy,
          bool synthetic = false}) =>
      _fixes.add(TrackedPoint(
        lat: lat,
        lng: lng,
        time: DateTime.utc(2026, 10, 6, 8),
        speed: speed,
        heading: heading,
        accuracy: accuracy,
        synthetic: synthetic,
      ));

  void serverEndsTrip() => _over.add(null);

  @override
  Future<void> start(String tripId) async => started.add(tripId);

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> dispose() async {
    await _fixes.close();
    await _over.close();
  }
}
