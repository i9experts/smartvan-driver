// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item_def.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistItemDef _$ChecklistItemDefFromJson(Map<String, dynamic> json) =>
    _ChecklistItemDef(
      key: json['key'] == null ? '' : looseStringOrEmpty(json['key']),
      label: json['label'] == null ? '' : looseStringOrEmpty(json['label']),
    );

Map<String, dynamic> _$ChecklistItemDefToJson(_ChecklistItemDef instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
    };
