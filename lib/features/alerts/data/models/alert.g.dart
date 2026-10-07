// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alert _$AlertFromJson(Map<String, dynamic> json) => _Alert(
      type: $enumDecodeNullable(_$AlertTypeEnumMap, readAlertType(json, 'type'),
              unknownValue: AlertType.unknown) ??
          AlertType.unknown,
      title: looseString(json['title']),
      message: looseString(readAlertMessage(json, 'message')),
      createdAt: looseDateTime(readAlertDate(json, 'createdAt')),
      tripId: looseString(json['tripId']),
      startTime: looseDateTime(json['startTime']),
    );

Map<String, dynamic> _$AlertToJson(_Alert instance) => <String, dynamic>{
      'type': _$AlertTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'tripId': instance.tripId,
      'startTime': instance.startTime?.toIso8601String(),
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
