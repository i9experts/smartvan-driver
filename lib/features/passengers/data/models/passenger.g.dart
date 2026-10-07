// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Passenger _$PassengerFromJson(Map<String, dynamic> json) => _Passenger(
      id: readKidId(json, 'id') == null
          ? ''
          : looseStringOrEmpty(readKidId(json, 'id')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
      image: looseString(readImage(json, 'image')),
      tripStatus: $enumDecodeNullable(
              _$KidTripStatusEnumMap, readTripStatus(json, 'tripStatus'),
              unknownValue: KidTripStatus.unknown) ??
          KidTripStatus.pending,
      tripId: looseString(json['tripId']),
      grade: looseString(json['grade']),
      schoolName: looseString(readSchoolName(json, 'schoolName')),
      distance: looseString(json['distance']),
      parent: readParentContact(json, 'parent') == null
          ? const ParentContact()
          : ParentContact.fromJson(
              readParentContact(json, 'parent') as Map<String, dynamic>),
      absent: json['absent'] == null ? false : looseBool(json['absent']),
      absenceNote: looseString(json['absenceNote']),
      waitingSince: looseDateTime(json['waitingSince']),
      noShow: json['noShow'] == null ? false : looseBool(json['noShow']),
    );

Map<String, dynamic> _$PassengerToJson(_Passenger instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'image': instance.image,
      'tripStatus': _$KidTripStatusEnumMap[instance.tripStatus]!,
      'tripId': instance.tripId,
      'grade': instance.grade,
      'schoolName': instance.schoolName,
      'distance': instance.distance,
      'parent': instance.parent,
      'absent': instance.absent,
      'absenceNote': instance.absenceNote,
      'waitingSince': instance.waitingSince?.toIso8601String(),
      'noShow': instance.noShow,
    };

const _$KidTripStatusEnumMap = {
  KidTripStatus.pending: 'pending',
  KidTripStatus.picked: 'picked',
  KidTripStatus.dropped: 'dropped',
  KidTripStatus.unknown: 'unknown',
};
