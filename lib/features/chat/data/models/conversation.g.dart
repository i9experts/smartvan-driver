// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: _readConversationId(json, 'id') == null
          ? ''
          : looseStringOrEmpty(_readConversationId(json, 'id')),
      otherUser: _readOtherUser(json, 'otherUser') == null
          ? const ChatUser()
          : ChatUser.fromJson(
              _readOtherUser(json, 'otherUser') as Map<String, dynamic>),
      kidNames: (_readKidNames(json, 'kidNames') as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastText: _text(_readLastText(json, 'lastText')),
      lastSenderType: looseString(_readLastSender(json, 'lastSenderType')),
      lastAt: looseLocalDateTime(_readLastAt(json, 'lastAt')),
      unread: json['unread'] == null ? 0 : _unread(json['unread']),
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'otherUser': instance.otherUser,
      'kidNames': instance.kidNames,
      'lastText': instance.lastText,
      'lastSenderType': instance.lastSenderType,
      'lastAt': instance.lastAt?.toIso8601String(),
      'unread': instance.unread,
    };
