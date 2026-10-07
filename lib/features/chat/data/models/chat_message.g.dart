// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
      id: _readMessageId(json, 'id') == null
          ? ''
          : looseStringOrEmpty(_readMessageId(json, 'id')),
      conversationId: json['conversationId'] == null
          ? ''
          : looseStringOrEmpty(json['conversationId']),
      senderType: json['senderType'] == null
          ? ''
          : looseStringOrEmpty(json['senderType']),
      text: json['text'] == null ? '' : _text(json['text']),
      createdAt: _createdAt(json['createdAt']),
      readAt: looseLocalDateTime(json['readAt']),
    );

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderType': instance.senderType,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };
