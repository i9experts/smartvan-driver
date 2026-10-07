// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanResult _$ScanResultFromJson(Map<String, dynamic> json) => _ScanResult(
      action: $enumDecodeNullable(_$ScanActionEnumMap, json['action'],
              unknownValue: ScanAction.unknown) ??
          ScanAction.unknown,
      kidId: readKidId(json, 'kidId') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'kidId')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
    );

Map<String, dynamic> _$ScanResultToJson(_ScanResult instance) =>
    <String, dynamic>{
      'action': _$ScanActionEnumMap[instance.action]!,
      'kidId': instance.kidId,
      'fullname': instance.fullname,
    };

const _$ScanActionEnumMap = {
  ScanAction.picked: 'picked',
  ScanAction.dropped: 'dropped',
  ScanAction.unknown: 'unknown',
};
