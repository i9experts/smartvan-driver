// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripStudent _$TripStudentFromJson(Map<String, dynamic> json) => _TripStudent(
      kidId: json['kidId'] == null ? '' : looseStringOrEmpty(json['kidId']),
      name: json['name'] == null ? '' : looseStringOrEmpty(json['name']),
      status: $enumDecodeNullable(
              _$StudentOutcomeEnumMap, _readStatus(json, 'status'),
              unknownValue: StudentOutcome.unknown) ??
          StudentOutcome.unknown,
      at: looseDateTime(json['at']),
    );

Map<String, dynamic> _$TripStudentToJson(_TripStudent instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'name': instance.name,
      'status': _$StudentOutcomeEnumMap[instance.status]!,
      'at': instance.at?.toIso8601String(),
    };

const _$StudentOutcomeEnumMap = {
  StudentOutcome.picked: 'picked',
  StudentOutcome.dropped: 'dropped',
  StudentOutcome.absent: 'absent',
  StudentOutcome.noShow: 'no_show',
  StudentOutcome.pending: 'pending',
  StudentOutcome.unknown: 'unknown',
};

_TripStop _$TripStopFromJson(Map<String, dynamic> json) => _TripStop(
      order: json['order'] == null ? 0 : _order(json['order']),
      placeName: looseString(json['placeName']),
      lat: looseDouble(json['lat']),
      lng: looseDouble(readLng(json, 'lng')),
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => TripStudent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TripStudent>[],
    );

Map<String, dynamic> _$TripStopToJson(_TripStop instance) => <String, dynamic>{
      'order': instance.order,
      'placeName': instance.placeName,
      'lat': instance.lat,
      'lng': instance.lng,
      'students': instance.students,
    };

_TripAlert _$TripAlertFromJson(Map<String, dynamic> json) => _TripAlert(
      type: $enumDecodeNullable(_$TripAlertKindEnumMap, _readType(json, 'type'),
              unknownValue: TripAlertKind.unknown) ??
          TripAlertKind.unknown,
      title: looseString(json['title']),
      message: looseString(json['message']),
      at: looseDateTime(json['at']),
    );

Map<String, dynamic> _$TripAlertToJson(_TripAlert instance) =>
    <String, dynamic>{
      'type': _$TripAlertKindEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'at': instance.at?.toIso8601String(),
    };

const _$TripAlertKindEnumMap = {
  TripAlertKind.sos: 'sos',
  TripAlertKind.overspeed: 'overspeed',
  TripAlertKind.trafficDelay: 'traffic_delay',
  TripAlertKind.trackingLost: 'tracking_lost',
  TripAlertKind.unknown: 'unknown',
};

_TripSchool _$TripSchoolFromJson(Map<String, dynamic> json) => _TripSchool(
      name: looseString(json['name']),
      lat: looseDouble(json['lat']),
      lng: looseDouble(readLng(json, 'lng')),
    );

Map<String, dynamic> _$TripSchoolToJson(_TripSchool instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
    };
