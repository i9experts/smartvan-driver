import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'driver_stats.freezed.dart';
part 'driver_stats.g.dart';

/// `GET /trips/driver-stats?days=7|30` → `data`.
@freezed
abstract class DriverStats with _$DriverStats {
  const factory DriverStats({
    /// 0–100.
    @JsonKey(fromJson: looseDouble) double? safetyScore,

    /// 0–100; absent when the driver had no timed trips.
    @JsonKey(fromJson: looseDouble) double? onTimePercent,
    @JsonKey(fromJson: _int) @Default(0) int overspeedCount,
    @JsonKey(fromJson: looseInt) int? speedLimitKmh,
    @JsonKey(fromJson: _int) @Default(0) int trips,
    @JsonKey(fromJson: _double) @Default(0) double distanceKm,
    @JsonKey(fromJson: _int) @Default(0) int drivingMinutes,
    @JsonKey(fromJson: _int) @Default(0) int kidsDropped,
    @JsonKey(fromJson: looseDouble) double? maxSpeedKmh,
  }) = _DriverStats;

  factory DriverStats.fromJson(Map<String, dynamic> json) =>
      _$DriverStatsFromJson(json);
}

int _int(Object? v) => looseInt(v) ?? 0;
double _double(Object? v) => looseDouble(v) ?? 0;
