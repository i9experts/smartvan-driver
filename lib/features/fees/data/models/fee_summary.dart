import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'fee_summary.freezed.dart';
part 'fee_summary.g.dart';

/// `GET /fees/driver-summary` → `data` (this month).
@freezed
abstract class FeeSummary with _$FeeSummary {
  const factory FeeSummary({
    @JsonKey(fromJson: looseString) String? currency,

    /// Students who have paid.
    @JsonKey(fromJson: _int) @Default(0) int paid,

    /// Students in total.
    @JsonKey(fromJson: _int) @Default(0) int students,
    @JsonKey(fromJson: _double) @Default(0) double collectedByYou,
    @JsonKey(fromJson: _double) @Default(0) double collectedOnline,
    @JsonKey(fromJson: _double) @Default(0) double totalPending,
  }) = _FeeSummary;

  factory FeeSummary.fromJson(Map<String, dynamic> json) =>
      _$FeeSummaryFromJson(json);
}

int _int(Object? v) => looseInt(v) ?? 0;
double _double(Object? v) => looseDouble(v) ?? 0;
