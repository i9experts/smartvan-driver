import 'package:json_annotation/json_annotation.dart';

/// Report-issue categories. The backend stores the display label.
enum IssueType {
  @JsonValue('Vehicle Issue')
  vehicleIssue,
  @JsonValue('Running Late')
  runningLate,
  @JsonValue('Passenger No-Show')
  passengerNoShow,
  @JsonValue('Emergency')
  emergency,
  @JsonValue('Tracking Not Working')
  trackingNotWorking,
  @JsonValue('Other')
  other,

  /// Anything the backend adds later.
  unknown,
}
