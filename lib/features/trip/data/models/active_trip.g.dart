// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveTrip _$ActiveTripFromJson(Map<String, dynamic> json) => _ActiveTrip(
      id: readId(json, 'id') == null
          ? ''
          : looseStringOrEmpty(readId(json, 'id')),
      routeId: looseString(json['routeId']),
      routeTitle: looseString(_readRouteTitle(json, 'schoolRoute')),
      name: looseString(_readName(json, 'tripName')),
      type: $enumDecodeNullable(_$TripTypeEnumMap, readTypeLower(json, 'type'),
              unknownValue: TripType.unknown) ??
          TripType.unknown,
      startTime: looseDateTime(readTripStartTime(json, 'startTime')),
    );

Map<String, dynamic> _$ActiveTripToJson(_ActiveTrip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'schoolRoute': instance.routeTitle,
      'tripName': instance.name,
      'type': _$TripTypeEnumMap[instance.type]!,
      'startTime': instance.startTime?.toIso8601String(),
    };

const _$TripTypeEnumMap = {
  TripType.pick: 'pick',
  TripType.drop: 'drop',
  TripType.unknown: 'unknown',
};
