// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alert _$AlertFromJson(Map<String, dynamic> json) => _Alert(
      id: looseString(readId(json, 'id')),
      type: $enumDecodeNullable(_$AlertTypeEnumMap, readAlertType(json, 'type'),
              unknownValue: AlertType.unknown) ??
          AlertType.unknown,
      title: looseString(json['title']),
      message: looseString(readAlertMessage(json, 'message')),
      createdAt: looseDateTime(readAlertDate(json, 'createdAt')),
      tripId: looseString(json['tripId']),
      startTime: looseDateTime(json['startTime']),
      date: looseDateTime(json['date']),
      shift: looseString(json['shift']),
    );

Map<String, dynamic> _$AlertToJson(_Alert instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'tripId': instance.tripId,
      'startTime': instance.startTime?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'shift': instance.shift,
    };

const _$AlertTypeEnumMap = {
  AlertType.sos: 'sos',
  AlertType.emergency: 'emergency',
  AlertType.payment: 'payment',
  AlertType.trip: 'trip',
  AlertType.newTrip: 'new_trip',
  AlertType.profile: 'profile',
  AlertType.documentExpiry: 'document_expiry',
  AlertType.unknown: 'unknown',
};
