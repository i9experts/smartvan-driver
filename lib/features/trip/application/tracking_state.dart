import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/active_trip.dart';
import '../data/models/geo_point.dart';

part 'tracking_state.freezed.dart';

/// What the tracking service is doing right now.
@freezed
abstract class TripTrackingState with _$TripTrackingState {
  const TripTrackingState._();

  const factory TripTrackingState({
    /// The trip on this phone (tracked or not).
    ActiveTrip? trip,
    @Default(false) bool isTracking,
    @Default(false) bool socketConnected,
    GeoPoint? lastPosition,

    /// Metres per second from the GPS fix (null if the device doesn't report
    /// it). Kept for upcoming overspeed monitoring.
    double? lastSpeed,
  }) = _TripTrackingState;

  String? get tripId => trip?.id;
}
