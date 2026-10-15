// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompletedTrip _$CompletedTripFromJson(Map<String, dynamic> json) =>
    _CompletedTrip(
      id: readId(json, 'id') == null
          ? ''
          : looseStringOrEmpty(readId(json, 'id')),
      routeName: looseString(json['routeName']),
      tripType: $enumDecodeNullable(
              _$TripTypeEnumMap, readTripTypeLower(json, 'tripType'),
              unknownValue: TripType.unknown) ??
          TripType.unknown,
      date: looseString(json['date']),
      startedAt: looseDateTime(json['startedAt']),
      endedAt: looseDateTime(json['endedAt']),
      durationSeconds:
          json['durationSeconds'] == null ? 0 : _count(json['durationSeconds']),
      distanceMeters:
          json['distanceMeters'] == null ? 0 : _count(json['distanceMeters']),
      studentCount:
          json['studentCount'] == null ? 0 : _count(json['studentCount']),
      pickedCount:
          json['pickedCount'] == null ? 0 : _count(json['pickedCount']),
      droppedCount:
          json['droppedCount'] == null ? 0 : _count(json['droppedCount']),
      absentCount:
          json['absentCount'] == null ? 0 : _count(json['absentCount']),
      noShowCount:
          json['noShowCount'] == null ? 0 : _count(json['noShowCount']),
    );

Map<String, dynamic> _$CompletedTripToJson(_CompletedTrip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeName': instance.routeName,
      'tripType': _$TripTypeEnumMap[instance.tripType]!,
      'date': instance.date,
      'startedAt': instance.startedAt?.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'distanceMeters': instance.distanceMeters,
      'studentCount': instance.studentCount,
      'pickedCount': instance.pickedCount,
      'droppedCount': instance.droppedCount,
      'absentCount': instance.absentCount,
      'noShowCount': instance.noShowCount,
    };

const _$TripTypeEnumMap = {
  TripType.pick: 'pick',
  TripType.drop: 'drop',
  TripType.unknown: 'unknown',
};
