// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
      id: looseString(readId(json, 'id')),
      status: $enumDecodeNullable(
              _$TripStatusEnumMap, readTripDocumentStatus(json, 'status'),
              unknownValue: TripStatus.unknown) ??
          TripStatus.unknown,
      type: $enumDecodeNullable(_$TripTypeEnumMap, json['type'],
              unknownValue: TripType.unknown) ??
          TripType.unknown,
      createdAt: looseDateTime(json['createdAt']),
      startTime: looseDateTime(readTripStartTime(json, 'startTime')),
      name: looseString(readTripName(json, 'name')),
      routeId: looseString(json['routeId']),
    );

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$TripStatusEnumMap[instance.status]!,
      'type': _$TripTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'name': instance.name,
      'routeId': instance.routeId,
    };

const _$TripStatusEnumMap = {
  TripStatus.pending: 'pending',
  TripStatus.ongoing: 'ongoing',
  TripStatus.completed: 'completed',
  TripStatus.unknown: 'unknown',
};

const _$TripTypeEnumMap = {
  TripType.pick: 'pick',
  TripType.drop: 'drop',
  TripType.unknown: 'unknown',
};
