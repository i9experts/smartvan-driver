// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimized_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OptimizedRoute _$OptimizedRouteFromJson(Map<String, dynamic> json) =>
    _OptimizedRoute(
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => OptimizedStop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OptimizedStop>[],
      origin: _point(json['origin']),
      destination: _point(json['destination']),
      distanceSavedMeters: json['distanceSavedMeters'] == null
          ? 0
          : _double(json['distanceSavedMeters']),
      durationSavedSeconds: json['durationSavedSeconds'] == null
          ? 0
          : _double(json['durationSavedSeconds']),
    );

Map<String, dynamic> _$OptimizedRouteToJson(_OptimizedRoute instance) =>
    <String, dynamic>{
      'stops': instance.stops,
      'origin': instance.origin,
      'destination': instance.destination,
      'distanceSavedMeters': instance.distanceSavedMeters,
      'durationSavedSeconds': instance.durationSavedSeconds,
    };

_OptimizedStop _$OptimizedStopFromJson(Map<String, dynamic> json) =>
    _OptimizedStop(
      sequence: looseInt(json['sequence']),
      kidName: looseString(json['kidName']),
      lat: looseDouble(json['lat']),
      lng: looseDouble(readLng(json, 'lng')),
    );

Map<String, dynamic> _$OptimizedStopToJson(_OptimizedStop instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'kidName': instance.kidName,
      'lat': instance.lat,
      'lng': instance.lng,
    };
