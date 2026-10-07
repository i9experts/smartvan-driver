import 'package:json_annotation/json_annotation.dart';

/// A kid's pickup state on the current trip.
enum KidTripStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('picked')
  picked,
  @JsonValue('dropped')
  dropped,

  /// Anything the backend adds later.
  unknown,
}
