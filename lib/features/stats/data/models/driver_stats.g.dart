// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverStats _$DriverStatsFromJson(Map<String, dynamic> json) => _DriverStats(
      safetyScore: looseDouble(json['safetyScore']),
      onTimePercent: looseDouble(json['onTimePercent']),
      overspeedCount:
          json['overspeedCount'] == null ? 0 : _int(json['overspeedCount']),
      speedLimitKmh: looseInt(json['speedLimitKmh']),
      trips: json['trips'] == null ? 0 : _int(json['trips']),
      distanceKm: json['distanceKm'] == null ? 0 : _double(json['distanceKm']),
      drivingMinutes:
          json['drivingMinutes'] == null ? 0 : _int(json['drivingMinutes']),
      kidsDropped: json['kidsDropped'] == null ? 0 : _int(json['kidsDropped']),
      maxSpeedKmh: looseDouble(json['maxSpeedKmh']),
    );

Map<String, dynamic> _$DriverStatsToJson(_DriverStats instance) =>
    <String, dynamic>{
      'safetyScore': instance.safetyScore,
      'onTimePercent': instance.onTimePercent,
      'overspeedCount': instance.overspeedCount,
      'speedLimitKmh': instance.speedLimitKmh,
      'trips': instance.trips,
      'distanceKm': instance.distanceKm,
      'drivingMinutes': instance.drivingMinutes,
      'kidsDropped': instance.kidsDropped,
      'maxSpeedKmh': instance.maxSpeedKmh,
    };
