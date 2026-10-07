// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid_absence_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KidAbsenceEvent _$KidAbsenceEventFromJson(Map<String, dynamic> json) =>
    _KidAbsenceEvent(
      kidId: readKidId(json, 'kidId') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'kidId')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
      date: looseDate(json['date']),
      tripType: $enumDecodeNullable(_$AbsenceTripTypeEnumMap, json['tripType'],
              unknownValue: AbsenceTripType.unknown) ??
          AbsenceTripType.unknown,
      cancelled:
          json['cancelled'] == null ? false : looseBool(json['cancelled']),
    );

Map<String, dynamic> _$KidAbsenceEventToJson(_KidAbsenceEvent instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'fullname': instance.fullname,
      'date': instance.date?.toIso8601String(),
      'tripType': _$AbsenceTripTypeEnumMap[instance.tripType]!,
      'cancelled': instance.cancelled,
    };

const _$AbsenceTripTypeEnumMap = {
  AbsenceTripType.pick: 'pick',
  AbsenceTripType.drop: 'drop',
  AbsenceTripType.both: 'both',
  AbsenceTripType.unknown: 'unknown',
};
