// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoPoint _$GeoPointFromJson(Map<String, dynamic> json) => _GeoPoint(
      lat: _toDouble(json['lat']),
      lng: _toDouble(readLng(json, 'lng')),
    );

Map<String, dynamic> _$GeoPointToJson(_GeoPoint instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
