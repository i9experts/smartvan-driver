import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/features/trip/services/trip_tracking_service.dart';

/// Stands in for the real tracking notifier (GPS, socket, foreground
/// service): fixed state and position.
class FakeTracking extends TripTrackingNotifier {
  FakeTracking({this.tripId, this.position});

  final String? tripId;
  final LatLng? position;

  @override
  TripTrackingState build() => TripTrackingState(
        trip: tripId == null ? null : {'_id': tripId},
        isTracking: tripId != null,
        lastPosition: position,
      );

  @override
  Future<LatLng?> currentPosition() async => position;
}
