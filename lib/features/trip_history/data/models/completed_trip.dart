import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import '../../../trip/data/models/trip_type.dart';

part 'completed_trip.freezed.dart';
part 'completed_trip.g.dart';

/// One finished trip of the driver: `GET /driver/trips/completed` → `items[]`
/// (and the top of `GET /driver/trips/:id/details`).
@freezed
abstract class CompletedTrip with _$CompletedTrip {
  const CompletedTrip._();

  const factory CompletedTrip({
    @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
    @Default('')
    String id,
    @JsonKey(fromJson: looseString) String? routeName,
    @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
    @Default(TripType.unknown)
    TripType tripType,

    /// Trip day, `YYYY-MM-DD` (PKT).
    @JsonKey(fromJson: looseString) String? date,
    @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
    @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
    @JsonKey(fromJson: _count) @Default(0) int durationSeconds,
    @JsonKey(fromJson: _count) @Default(0) int distanceMeters,
    @JsonKey(fromJson: _count) @Default(0) int studentCount,
    @JsonKey(fromJson: _count) @Default(0) int pickedCount,
    @JsonKey(fromJson: _count) @Default(0) int droppedCount,
    @JsonKey(fromJson: _count) @Default(0) int absentCount,
    @JsonKey(fromJson: _count) @Default(0) int noShowCount,
  }) = _CompletedTrip;

  factory CompletedTrip.fromJson(Map<String, dynamic> json) =>
      _$CompletedTripFromJson(json);

  /// The moment that decides the trip's day: when it ended, else started,
  /// else the `date` field.
  DateTime? get when =>
      endedAt ?? startedAt ?? (date == null ? null : DateTime.tryParse(date!));
}

int _count(Object? v) => looseInt(v) ?? 0;
