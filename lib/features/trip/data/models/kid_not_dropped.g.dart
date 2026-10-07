// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid_not_dropped.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KidNotDropped _$KidNotDroppedFromJson(Map<String, dynamic> json) =>
    _KidNotDropped(
      kidId: readKidId(json, 'kidId') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'kidId')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
    );

Map<String, dynamic> _$KidNotDroppedToJson(_KidNotDropped instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'fullname': instance.fullname,
    };
