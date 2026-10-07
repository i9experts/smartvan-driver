// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => _ChatUser(
      id: json['id'] == null ? '' : looseStringOrEmpty(json['id']),
      type: json['type'] == null ? '' : looseStringOrEmpty(json['type']),
      name: json['name'] == null ? '' : looseStringOrEmpty(json['name']),
      image: looseString(json['image']),
    );

Map<String, dynamic> _$ChatUserToJson(_ChatUser instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'image': instance.image,
    };
