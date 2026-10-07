// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistRecord _$ChecklistRecordFromJson(Map<String, dynamic> json) =>
    _ChecklistRecord(
      allOk: _nullableBool(json['allOk']),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ChecklistAnswer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChecklistAnswer>[],
      photoUrl: looseString(json['photoUrl']),
    );

Map<String, dynamic> _$ChecklistRecordToJson(_ChecklistRecord instance) =>
    <String, dynamic>{
      'allOk': instance.allOk,
      'items': instance.items,
      'photoUrl': instance.photoUrl,
    };
