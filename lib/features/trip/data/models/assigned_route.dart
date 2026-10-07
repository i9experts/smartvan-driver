import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'route_passenger.dart';
import 'trip.dart';
import 'trip_type.dart';

part 'assigned_route.freezed.dart';
part 'assigned_route.g.dart';

/// One route from `GET /route/getAssignedTripByDriver`.
@freezed
abstract class AssignedRoute with _$AssignedRoute {
  const factory AssignedRoute({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String routeId,
    @JsonKey(fromJson: looseString) String? routeTitle,
    @JsonKey(fromJson: looseString) String? vehicleNumber,

    /// UTC ISO timestamp; the app only uses hours and minutes of it.
    @JsonKey(fromJson: looseDateTime) DateTime? startTime,
    @JsonKey(unknownEnumValue: TripType.unknown)
    @Default(TripType.unknown)
    TripType tripType,

    /// Backend key is `TripStarted` (PascalCase).
    @JsonKey(readValue: readTripStarted, fromJson: looseBool)
    @Default(false)
    bool tripStarted,

    /// The running trip, when [tripStarted].
    Trip? tripDetails,
    @Default(<RoutePassenger>[]) List<RoutePassenger> passengers,
  }) = _AssignedRoute;

  factory AssignedRoute.fromJson(Map<String, dynamic> json) =>
      _$AssignedRouteFromJson(json);
}
