// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignedRoute _$AssignedRouteFromJson(Map<String, dynamic> json) =>
    _AssignedRoute(
      routeId:
          json['routeId'] == null ? '' : looseStringOrEmpty(json['routeId']),
      routeTitle: looseString(json['routeTitle']),
      vehicleNumber: looseString(json['vehicleNumber']),
      startTime: looseDateTime(json['startTime']),
      tripType: $enumDecodeNullable(_$TripTypeEnumMap, json['tripType'],
              unknownValue: TripType.unknown) ??
          TripType.unknown,
      tripStarted: readTripStarted(json, 'tripStarted') == null
          ? false
          : looseBool(readTripStarted(json, 'tripStarted')),
      todayStatus: $enumDecodeNullable(
              _$TodayStatusEnumMap, json['todayStatus'],
              unknownValue: TodayStatus.unknown) ??
          TodayStatus.unknown,
      tripCompleted: readTripCompleted(json, 'tripCompleted') == null
          ? false
          : looseBool(readTripCompleted(json, 'tripCompleted')),
      tripDetails: json['tripDetails'] == null
          ? null
          : Trip.fromJson(json['tripDetails'] as Map<String, dynamic>),
      passengers: (json['passengers'] as List<dynamic>?)
              ?.map((e) => RoutePassenger.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RoutePassenger>[],
    );

Map<String, dynamic> _$AssignedRouteToJson(_AssignedRoute instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeTitle': instance.routeTitle,
      'vehicleNumber': instance.vehicleNumber,
      'startTime': instance.startTime?.toIso8601String(),
      'tripType': _$TripTypeEnumMap[instance.tripType]!,
      'tripStarted': instance.tripStarted,
      'todayStatus': _$TodayStatusEnumMap[instance.todayStatus]!,
      'tripCompleted': instance.tripCompleted,
      'tripDetails': instance.tripDetails,
      'passengers': instance.passengers,
    };

const _$TripTypeEnumMap = {
  TripType.pick: 'pick',
  TripType.drop: 'drop',
  TripType.unknown: 'unknown',
};

const _$TodayStatusEnumMap = {
  TodayStatus.notStarted: 'not_started',
  TodayStatus.ongoing: 'ongoing',
  TodayStatus.completed: 'completed',
  TodayStatus.unknown: 'unknown',
};
