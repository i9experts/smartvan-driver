import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'rating_summary.freezed.dart';
part 'rating_summary.g.dart';

/// `GET /rating/myRatingSummary` → the driver's lifetime rating.
@freezed
abstract class RatingSummary with _$RatingSummary {
  const factory RatingSummary({
    /// 0 when nobody has rated yet.
    @JsonKey(fromJson: _double) @Default(0) double avgRating,
    @JsonKey(fromJson: _int) @Default(0) int ratingCount,
    @JsonKey(fromJson: _int) @Default(0) int completedTripCount,
  }) = _RatingSummary;

  factory RatingSummary.fromJson(Map<String, dynamic> json) =>
      _$RatingSummaryFromJson(json);
}

int _int(Object? v) => looseInt(v) ?? 0;
double _double(Object? v) => looseDouble(v) ?? 0;
