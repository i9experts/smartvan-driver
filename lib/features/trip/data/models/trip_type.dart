import 'package:json_annotation/json_annotation.dart';

/// Direction of a trip (and of the route it belongs to).
enum TripType {
  @JsonValue('pick')
  pick,
  @JsonValue('drop')
  drop,

  /// Anything the backend adds later.
  unknown,
}
