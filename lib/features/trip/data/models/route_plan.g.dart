// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutePlan _$RoutePlanFromJson(Map<String, dynamic> json) => _RoutePlan(
      nextStopOrder: looseInt(json['nextStopOrder']),
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => RoutePlanStop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RoutePlanStop>[],
      school: json['school'] == null
          ? null
          : RoutePlanSchool.fromJson(json['school'] as Map<String, dynamic>),
      plannedPath: json['plannedPath'] == null
          ? null
          : PlannedPath.fromJson(json['plannedPath'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoutePlanToJson(_RoutePlan instance) =>
    <String, dynamic>{
      'nextStopOrder': instance.nextStopOrder,
      'stops': instance.stops,
      'school': instance.school,
      'plannedPath': instance.plannedPath,
    };

_RoutePlanStop _$RoutePlanStopFromJson(Map<String, dynamic> json) =>
    _RoutePlanStop(
      order: json['order'] == null ? 0 : _order(json['order']),
      kidId: looseString(json['kidId']),
      fullname: looseString(json['fullname']),
      lat: looseDouble(json['lat']),
      lng: looseDouble(readLng(json, 'lng')),
      status: $enumDecodeNullable(_$StopStatusEnumMap, json['status'],
              unknownValue: StopStatus.unknown) ??
          StopStatus.waiting,
    );

Map<String, dynamic> _$RoutePlanStopToJson(_RoutePlanStop instance) =>
    <String, dynamic>{
      'order': instance.order,
      'kidId': instance.kidId,
      'fullname': instance.fullname,
      'lat': instance.lat,
      'lng': instance.lng,
      'status': _$StopStatusEnumMap[instance.status]!,
    };

const _$StopStatusEnumMap = {
  StopStatus.waiting: 'waiting',
  StopStatus.picked: 'picked',
  StopStatus.dropped: 'dropped',
  StopStatus.absent: 'absent',
  StopStatus.noShow: 'no_show',
  StopStatus.unknown: 'unknown',
};

_RoutePlanSchool _$RoutePlanSchoolFromJson(Map<String, dynamic> json) =>
    _RoutePlanSchool(
      name: looseString(json['name']),
      lat: looseDouble(json['lat']),
      lng: looseDouble(readLng(json, 'lng')),
    );

Map<String, dynamic> _$RoutePlanSchoolToJson(_RoutePlanSchool instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_PlannedPath _$PlannedPathFromJson(Map<String, dynamic> json) => _PlannedPath(
      polyline: looseString(json['polyline']),
    );

Map<String, dynamic> _$PlannedPathToJson(_PlannedPath instance) =>
    <String, dynamic>{
      'polyline': instance.polyline,
    };
