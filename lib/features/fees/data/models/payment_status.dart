import 'package:json_annotation/json_annotation.dart';

/// Status of a kid's transport fee for a month.
enum PaymentStatus {
  @JsonValue('paid')
  paid,
  @JsonValue('overdue')
  overdue,
  @JsonValue('pending')
  pending,
  @JsonValue('not_generated')
  notGenerated,

  /// Anything the backend adds later.
  unknown,
}
