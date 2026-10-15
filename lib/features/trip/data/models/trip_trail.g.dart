// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrailPoint _$TrailPointFromJson(Map<String, dynamic> json) => _TrailPoint(
      lat: _toDouble(json['lat']),
      lng: _toDouble(readLng(json, 'lng')),
      t: looseDateTime(json['t']),
    );

Map<String, dynamic> _$TrailPointToJson(_TrailPoint instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      't': instance.t?.toIso8601String(),
    };

_TripTrail _$TripTrailFromJson(Map<String, dynamic> json) => _TripTrail(
      polyline: looseString(json['polyline']),
      path: (json['path'] as List<dynamic>?)
              ?.map((e) => TrailPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TrailPoint>[],
      start: json['start'] == null
          ? null
          : TrailPoint.fromJson(json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : TrailPoint.fromJson(json['end'] as Map<String, dynamic>),
      endedAt: looseDateTime(json['endedAt']),
    );

Map<String, dynamic> _$TripTrailToJson(_TripTrail instance) =>
    <String, dynamic>{
      'polyline': instance.polyline,
      'path': instance.path,
      'start': instance.start,
      'end': instance.end,
      'endedAt': instance.endedAt?.toIso8601String(),
    };
