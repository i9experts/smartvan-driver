// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParentContact _$ParentContactFromJson(Map<String, dynamic> json) =>
    _ParentContact(
      phoneNo: looseString(json['phoneNo']),
      alternatePhoneNo: looseString(json['alternatePhoneNo']),
      address: looseString(json['address']),
    );

Map<String, dynamic> _$ParentContactToJson(_ParentContact instance) =>
    <String, dynamic>{
      'phoneNo': instance.phoneNo,
      'alternatePhoneNo': instance.alternatePhoneNo,
      'address': instance.address,
    };
