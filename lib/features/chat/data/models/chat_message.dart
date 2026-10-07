import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// A chat message (REST, and the `chatMessage` socket event).
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// Backend key: `messageId`.
    @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
    @Default('')
    String id,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String conversationId,

    /// `parent` | `driver`.
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String senderType,

    /// Kept exactly as sent (no trimming).
    @JsonKey(fromJson: _text) @Default('') String text,

    /// Local time. A missing / broken timestamp becomes "now".
    @JsonKey(fromJson: _createdAt) required DateTime createdAt,

    /// Local time; null while unread.
    @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,

    /// Local-only: still sending. Never comes from or goes to the backend.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool pending,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

Object? _readMessageId(Map<dynamic, dynamic> m, String _) => m['messageId'];

String _text(Object? v) => v?.toString() ?? '';

DateTime _createdAt(Object? v) => looseLocalDateTime(v) ?? DateTime.now();
