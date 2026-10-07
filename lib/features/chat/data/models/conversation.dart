import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'chat_user.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// One row of `GET /chat/conversations` (also the answer of `/chat/start`).
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    /// Backend key: `conversationId`.
    @JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
    @Default('')
    String id,
    @JsonKey(readValue: _readOtherUser) @Default(ChatUser()) ChatUser otherUser,

    /// Names of the kids the conversation is about (`kids[].fullname`).
    @JsonKey(readValue: _readKidNames)
    @Default(<String>[])
    List<String> kidNames,

    /// `lastMessage.text`
    @JsonKey(readValue: _readLastText, fromJson: _text) String? lastText,

    /// `lastMessage.senderType`
    @JsonKey(readValue: _readLastSender, fromJson: looseString)
    String? lastSenderType,

    /// `lastMessage.at`, in local time.
    @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
    DateTime? lastAt,
    @JsonKey(fromJson: _unread) @Default(0) int unread,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

Object? _readConversationId(Map<dynamic, dynamic> m, String _) =>
    m['conversationId'];

Object? _readOtherUser(Map<dynamic, dynamic> m, String _) =>
    m['otherUser'] is Map ? m['otherUser'] : const <String, dynamic>{};

Object? _readKidNames(Map<dynamic, dynamic> m, String _) {
  final kids = m['kids'];
  if (kids is! List) return const <String>[];
  return kids
      .whereType<Map<dynamic, dynamic>>()
      .map((k) => k['fullname']?.toString() ?? '')
      .where((n) => n.isNotEmpty)
      .toList();
}

Object? _readLastText(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'lastMessage', 'text');

Object? _readLastSender(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'lastMessage', 'senderType');

Object? _readLastAt(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'lastMessage', 'at');

String? _text(Object? v) => v?.toString();

int _unread(Object? v) => looseInt(v) ?? 0;
