import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'completed_trip.dart';

part 'trip_details.freezed.dart';
part 'trip_details.g.dart';

/// What happened to a student on the trip.
enum StudentOutcome {
  @JsonValue('picked')
  picked,
  @JsonValue('dropped')
  dropped,
  @JsonValue('absent')
  absent,
  @JsonValue('no_show')
  noShow,
  @JsonValue('pending')
  pending,

  /// Anything the backend adds later.
  unknown,
}

/// What kind of alert was raised for the van during the trip.
enum TripAlertKind {
  @JsonValue('sos')
  sos,
  @JsonValue('overspeed')
  overspeed,
  @JsonValue('traffic_delay')
  trafficDelay,
  @JsonValue('tracking_lost')
  trackingLost,

  /// Anything the backend adds later.
  unknown,
}

@freezed
abstract class TripStudent with _$TripStudent {
  const factory TripStudent({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String kidId,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String name,
    @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
    @Default(StudentOutcome.unknown)
    StudentOutcome status,
    @JsonKey(fromJson: looseDateTime) DateTime? at,
  }) = _TripStudent;

  factory TripStudent.fromJson(Map<String, dynamic> json) =>
      _$TripStudentFromJson(json);
}

@freezed
abstract class TripStop with _$TripStop {
  const factory TripStop({
    @JsonKey(fromJson: _order) @Default(0) int order,
    @JsonKey(fromJson: looseString) String? placeName,
    @JsonKey(fromJson: looseDouble) double? lat,
    @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
    @Default(<TripStudent>[]) List<TripStudent> students,
  }) = _TripStop;

  factory TripStop.fromJson(Map<String, dynamic> json) =>
      _$TripStopFromJson(json);
}

@freezed
abstract class TripAlert with _$TripAlert {
  const factory TripAlert({
    @JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
    @Default(TripAlertKind.unknown)
    TripAlertKind type,
    @JsonKey(fromJson: looseString) String? title,
    @JsonKey(fromJson: looseString) String? message,
    @JsonKey(fromJson: looseDateTime) DateTime? at,
  }) = _TripAlert;

  factory TripAlert.fromJson(Map<String, dynamic> json) =>
      _$TripAlertFromJson(json);
}

@freezed
abstract class TripSchool with _$TripSchool {
  const factory TripSchool({
    @JsonKey(fromJson: looseString) String? name,
    @JsonKey(fromJson: looseDouble) double? lat,
    @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
  }) = _TripSchool;

  factory TripSchool.fromJson(Map<String, dynamic> json) =>
      _$TripSchoolFromJson(json);
}

/// `GET /driver/trips/:id/details`: the trip summary plus stops with their
/// students, the alerts raised during it and the school.
@freezed
abstract class TripDetails with _$TripDetails {
  const TripDetails._();

  const factory TripDetails({
    required CompletedTrip trip,
    @Default(<TripStop>[]) List<TripStop> stops,
    @Default(<TripAlert>[]) List<TripAlert> alerts,
    TripSchool? school,
  }) = _TripDetails;

  factory TripDetails.fromJson(Map<String, dynamic> json) {
    final school = json['school'];
    return TripDetails(
      trip: CompletedTrip.fromJson(json),
      stops: asJsonList(json['stops']).map(TripStop.fromJson).toList(),
      alerts: asJsonList(json['alerts']).map(TripAlert.fromJson).toList(),
      school: school is Map ? TripSchool.fromJson(asJsonMap(school)) : null,
    );
  }

  /// Every student of every stop, in stop order.
  List<TripStudent> get students => [for (final s in stops) ...s.students];
}

Object? _readStatus(Map<dynamic, dynamic> m, String _) =>
    lowerCased(m['status']);

Object? _readType(Map<dynamic, dynamic> m, String _) => lowerCased(m['type']);

int _order(Object? v) => looseInt(v) ?? 0;
