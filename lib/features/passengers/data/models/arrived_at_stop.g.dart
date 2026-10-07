// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arrived_at_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArrivedAtStop _$ArrivedAtStopFromJson(Map<String, dynamic> json) =>
    _ArrivedAtStop(
      kidId: readKidId(json, 'kidId') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'kidId')),
      waitingSince: looseDateTime(json['waitingSince']),
    );

Map<String, dynamic> _$ArrivedAtStopToJson(_ArrivedAtStop instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'waitingSince': instance.waitingSince?.toIso8601String(),
    };
