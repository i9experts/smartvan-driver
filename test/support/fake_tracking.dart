import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/application/tracking_state.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

/// Stands in for the real tracking notifier (GPS, socket, foreground
/// service): fixed state and position.
class FakeTracking extends TripTracking {
  FakeTracking({String? tripId, GeoPoint? position})
      : _tripId = tripId,
        _position = position;

  final String? _tripId;
  final GeoPoint? _position;

  @override
  TripTrackingState build() => TripTrackingState(
        trip: _tripId == null ? null : ActiveTrip(id: _tripId),
        isTracking: _tripId != null,
        lastPosition: _position,
      );

  @override
  Future<GeoPoint?> currentPosition() async => _position;
}
