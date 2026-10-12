import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'geo_point.dart';

part 'optimized_route.freezed.dart';
part 'optimized_route.g.dart';

/// `POST /trips/optimizeRoute` → `data`: the route's stops in the suggested
/// order, with what following it saves against the planned order.
@freezed
abstract class OptimizedRoute with _$OptimizedRoute {
  const OptimizedRoute._();

  const factory OptimizedRoute({
    @Default(<OptimizedStop>[]) List<OptimizedStop> stops,

    /// Where the suggestion starts (the driver's position) — absent means
    /// there is nothing to navigate.
    @JsonKey(fromJson: _point) GeoPoint? origin,
    @JsonKey(fromJson: _point) GeoPoint? destination,
    @JsonKey(fromJson: _double) @Default(0) double distanceSavedMeters,
    @JsonKey(fromJson: _double) @Default(0) double durationSavedSeconds,
  }) = _OptimizedRoute;

  factory OptimizedRoute.fromJson(Map<String, dynamic> json) =>
      _$OptimizedRouteFromJson(json);

  double get distanceSavedKm => distanceSavedMeters / 1000;
  double get durationSavedMinutes => durationSavedSeconds / 60;

  /// Worth telling the driver about (more than 50 m or half a minute).
  bool get hasSavings => distanceSavedKm > 0.05 || durationSavedMinutes > 0.5;
}

/// One stop of the suggested order.
@freezed
abstract class OptimizedStop with _$OptimizedStop {
  const factory OptimizedStop({
    /// 1-based position in the suggested order.
    @JsonKey(fromJson: looseInt) int? sequence,
    @JsonKey(fromJson: looseString) String? kidName,
    @JsonKey(fromJson: looseDouble) double? lat,
    @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
  }) = _OptimizedStop;

  factory OptimizedStop.fromJson(Map<String, dynamic> json) =>
      _$OptimizedStopFromJson(json);
}

double _double(Object? v) => looseDouble(v) ?? 0;

/// A `{lat, lng}` object, or null when it or one of its numbers is missing.
GeoPoint? _point(Object? v) {
  if (v is! Map) return null;
  if (looseDouble(v['lat']) == null || looseDouble(readLng(v, 'lng')) == null) {
    return null;
  }
  return GeoPoint.fromJson(Map<String, dynamic>.from(v));
}
