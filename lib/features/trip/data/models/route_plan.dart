import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'stop_status.dart';

part 'route_plan.freezed.dart';
part 'route_plan.g.dart';

/// `GET /trips/:tripId/route-plan` → `data`: the stops in visiting order
/// with their state, the school, and the road path still ahead.
@freezed
abstract class RoutePlan with _$RoutePlan {
  const RoutePlan._();

  const factory RoutePlan({
    @JsonKey(fromJson: looseInt) int? nextStopOrder,
    @Default(<RoutePlanStop>[]) List<RoutePlanStop> stops,
    RoutePlanSchool? school,
    PlannedPath? plannedPath,
  }) = _RoutePlan;

  factory RoutePlan.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanFromJson(json);

  /// Stops with a real position. A kid whose home was never set comes as
  /// 0, 0 (the Gulf of Guinea) — that is not a place to draw.
  List<RoutePlanStop> get drawableStops =>
      stops.where((s) => hasPosition(s.lat, s.lng)).toList();
}

@freezed
abstract class RoutePlanStop with _$RoutePlanStop {
  const factory RoutePlanStop({
    /// 1-based position in the visiting order.
    @JsonKey(fromJson: _order) @Default(0) int order,
    @JsonKey(fromJson: looseString) String? kidId,
    @JsonKey(fromJson: looseString) String? fullname,
    @JsonKey(fromJson: looseDouble) double? lat,
    @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
    @JsonKey(unknownEnumValue: StopStatus.unknown)
    @Default(StopStatus.waiting)
    StopStatus status,
  }) = _RoutePlanStop;

  factory RoutePlanStop.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanStopFromJson(json);
}

@freezed
abstract class RoutePlanSchool with _$RoutePlanSchool {
  const factory RoutePlanSchool({
    @JsonKey(fromJson: looseString) String? name,
    @JsonKey(fromJson: looseDouble) double? lat,
    @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
  }) = _RoutePlanSchool;

  factory RoutePlanSchool.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanSchoolFromJson(json);
}

/// The road-following path from the van through the remaining stops.
@freezed
abstract class PlannedPath with _$PlannedPath {
  const factory PlannedPath({
    @JsonKey(fromJson: looseString) String? polyline,
  }) = _PlannedPath;

  factory PlannedPath.fromJson(Map<String, dynamic> json) =>
      _$PlannedPathFromJson(json);
}

int _order(Object? v) => looseInt(v) ?? 0;

/// True when both numbers are there and are not the 0, 0 "unset" placeholder.
bool hasPosition(double? lat, double? lng) =>
    lat != null && lng != null && !(lat == 0 && lng == 0);
