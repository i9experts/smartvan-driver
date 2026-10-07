// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutePassenger _$RoutePassengerFromJson(Map<String, dynamic> json) =>
    _RoutePassenger(
      kidId: readKidId(json, 'kidId') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'kidId')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
      image: looseString(readImage(json, 'image')),
      grade: looseString(json['grade']),
    );

Map<String, dynamic> _$RoutePassengerToJson(_RoutePassenger instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'fullname': instance.fullname,
      'image': instance.image,
      'grade': instance.grade,
    };
