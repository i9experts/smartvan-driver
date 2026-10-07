// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Absence _$AbsenceFromJson(Map<String, dynamic> json) => _Absence(
      absenceId: json['absenceId'] == null
          ? ''
          : looseStringOrEmpty(json['absenceId']),
      kidId: json['kidId'] == null ? '' : looseStringOrEmpty(json['kidId']),
      date: looseDate(json['date']),
      tripType: $enumDecodeNullable(_$AbsenceTripTypeEnumMap, json['tripType'],
              unknownValue: AbsenceTripType.unknown) ??
          AbsenceTripType.unknown,
      note: looseString(json['note']),
      createdAt: looseDateTime(json['createdAt']),
    );

Map<String, dynamic> _$AbsenceToJson(_Absence instance) => <String, dynamic>{
      'absenceId': instance.absenceId,
      'kidId': instance.kidId,
      'date': instance.date?.toIso8601String(),
      'tripType': _$AbsenceTripTypeEnumMap[instance.tripType]!,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$AbsenceTripTypeEnumMap = {
  AbsenceTripType.pick: 'pick',
  AbsenceTripType.drop: 'drop',
  AbsenceTripType.both: 'both',
  AbsenceTripType.unknown: 'unknown',
};
