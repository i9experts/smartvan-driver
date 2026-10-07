import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'trip_status.dart';
import 'trip_type.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// A trip document (`/trips/startTrip`, `/trips/getDriverTrips`).
///
/// Keys the app used to inject into the same map (`schoolRoute`,
/// `passengers`) are not part of the model.
@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    @JsonKey(readValue: readId, fromJson: looseString) String? id,
    @JsonKey(
        readValue: readTripDocumentStatus, unknownEnumValue: TripStatus.unknown)
    @Default(TripStatus.unknown)
    TripStatus status,
    @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
    @Default(TripType.unknown)
    TripType type,
    @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
    @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
    DateTime? startTime,
    @JsonKey(readValue: readTripName, fromJson: looseString) String? name,
    @JsonKey(fromJson: looseString) String? routeId,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
