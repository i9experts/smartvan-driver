import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'geo_point.dart';

part 'trip_trail.freezed.dart';
part 'trip_trail.g.dart';

/// One recorded GPS point of a trail.
@freezed
abstract class TrailPoint with _$TrailPoint {
  const factory TrailPoint({
    @JsonKey(fromJson: _toDouble) required double lat,
    @JsonKey(readValue: readLng, fromJson: _toDouble) required double lng,
    @JsonKey(fromJson: looseDateTime) DateTime? t,
  }) = _TrailPoint;

  factory TrailPoint.fromJson(Map<String, dynamic> json) =>
      _$TrailPointFromJson(json);
}

/// `GET /trips/:tripId/trail` → `data`: where the van actually drove.
///
/// `polyline` (encoded) is what the live trip screen has always used; `path`
/// (at most 1000 simplified points, first and last kept) plus `start` / `end`
/// were added for trip history.
@freezed
abstract class TripTrail with _$TripTrail {
  const TripTrail._();

  const factory TripTrail({
    @JsonKey(fromJson: looseString) String? polyline,
    @Default(<TrailPoint>[]) List<TrailPoint> path,
    TrailPoint? start,
    TrailPoint? end,
    @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
  }) = _TripTrail;

  factory TripTrail.fromJson(Map<String, dynamic> json) =>
      _$TripTrailFromJson(json);

  /// The driven path as points.
  List<GeoPoint> get pathPoints =>
      [for (final p in path) GeoPoint(lat: p.lat, lng: p.lng)];
}

double _toDouble(Object? v) => looseDouble(v) ?? 0;
