// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_checklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodayChecklist _$TodayChecklistFromJson(Map<String, dynamic> json) =>
    _TodayChecklist(
      checklist: json['data'] == null
          ? null
          : ChecklistRecord.fromJson(json['data'] as Map<String, dynamic>),
      required: json['required'] == null ? false : looseBool(json['required']),
    );

Map<String, dynamic> _$TodayChecklistToJson(_TodayChecklist instance) =>
    <String, dynamic>{
      'data': instance.checklist,
      'required': instance.required,
    };
