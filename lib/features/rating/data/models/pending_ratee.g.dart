// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_ratee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingRatee _$PendingRateeFromJson(Map<String, dynamic> json) =>
    _PendingRatee(
      tripId: json['tripId'] == null ? '' : looseStringOrEmpty(json['tripId']),
      parentId:
          json['parentId'] == null ? '' : looseStringOrEmpty(json['parentId']),
      parentName: looseString(json['parentName']),
      parentImage: looseString(json['parentImage']),
    );

Map<String, dynamic> _$PendingRateeToJson(_PendingRatee instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'parentId': instance.parentId,
      'parentName': instance.parentName,
      'parentImage': instance.parentImage,
    };
