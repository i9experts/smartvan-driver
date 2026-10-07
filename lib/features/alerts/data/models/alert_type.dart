import 'package:json_annotation/json_annotation.dart';

enum AlertType {
  @JsonValue('sos')
  sos,
  @JsonValue('emergency')
  emergency,
  @JsonValue('payment')
  payment,
  @JsonValue('trip')
  trip,
  @JsonValue('new_trip')
  newTrip,
  @JsonValue('profile')
  profile,

  /// Licence / vehicle card about to expire (backend Phase 4).
  @JsonValue('document_expiry')
  documentExpiry,

  /// Anything the backend adds later.
  unknown,
}
