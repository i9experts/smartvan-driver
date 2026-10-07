import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/application/tracking_state.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

/// What a [FakeTracking] was asked to do, and what it should answer.
class TrackingProbe {
  final List<ActiveTrip> started = [];
  int ends = 0;
  int stops = 0;
  bool? lastForceEnd;
  String? lastNote;
  TrackingStartResult startResult = TrackingStartResult.started;

  /// Thrown by `endTrip` when set.
  Object? endError;
}

/// Stands in for the real tracking notifier (GPS, socket, foreground
/// service): fixed state and position, scripted answers.
class FakeTracking extends TripTracking {
  FakeTracking({
    String? tripId,
    GeoPoint? position,
    bool socketConnected = false,
    bool? isTracking,
    TrackingProbe? probe,
  })  : _tripId = tripId,
        _position = position,
        _socketConnected = socketConnected,
        _isTracking = isTracking,
        _probe = probe ?? TrackingProbe();

  final String? _tripId;
  final GeoPoint? _position;
  final bool _socketConnected;
  final bool? _isTracking;
  final TrackingProbe _probe;

  @override
  TripTrackingState build() => TripTrackingState(
        trip: _tripId == null
            ? null
            : ActiveTrip(
                id: _tripId,
                name: 'Sample School - Morning Pick',
                routeTitle: 'Sample School - Morning'),
        isTracking: _isTracking ?? _tripId != null,
        socketConnected: _socketConnected,
        lastPosition: _position,
      );

  @override
  Future<TrackingStartResult> start(ActiveTrip trip) async {
    _probe.started.add(trip);
    return _probe.startResult;
  }

  @override
  Future<void> stop() async {
    _probe.stops += 1;
    state = const TripTrackingState();
  }

  @override
  Future<void> endTrip(
      {bool forceEnd = false, String? confirmationNote}) async {
    _probe
      ..ends += 1
      ..lastForceEnd = forceEnd
      ..lastNote = confirmationNote;
    final error = _probe.endError;
    if (error != null) throw error;
    state = const TripTrackingState();
  }

  @override
  Future<GeoPoint?> currentPosition() async => _position;
}
