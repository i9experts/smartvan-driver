import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'geo_point.freezed.dart';
part 'geo_point.g.dart';

/// `{lat, lng}` — the one location value type. The backend spells longitude
/// `lng` on some endpoints and `long` on others; both are read, and this
/// always writes `lng`.
@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint({
    @JsonKey(fromJson: _toDouble) required double lat,
    @JsonKey(readValue: readLng, fromJson: _toDouble) required double lng,
  }) = _GeoPoint;

  factory GeoPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoPointFromJson(json);
}

double _toDouble(Object? v) => looseDouble(v) ?? 0;
