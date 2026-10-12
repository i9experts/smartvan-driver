import 'package:json_annotation/json_annotation.dart';

/// Where a route's trip stands today (`todayStatus` of
/// `GET /Route/getAssignedTripByDriver`). A route runs once a day.
enum TodayStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('completed')
  completed,

  /// Missing, or anything the backend adds later.
  unknown,
}
