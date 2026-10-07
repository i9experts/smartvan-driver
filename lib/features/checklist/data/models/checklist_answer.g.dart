// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistAnswer _$ChecklistAnswerFromJson(Map<String, dynamic> json) =>
    _ChecklistAnswer(
      key: json['key'] == null ? '' : looseStringOrEmpty(json['key']),
      ok: json['ok'] == null ? false : looseBool(json['ok']),
      note: looseString(json['note']),
    );

Map<String, dynamic> _$ChecklistAnswerToJson(_ChecklistAnswer instance) =>
    <String, dynamic>{
      'key': instance.key,
      'ok': instance.ok,
      if (instance.note case final value?) 'note': value,
    };
