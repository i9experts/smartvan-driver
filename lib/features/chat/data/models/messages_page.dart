import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';

part 'messages_page.freezed.dart';

/// One page of `GET /chat/{id}/messages`, newest message first.
@freezed
abstract class MessagesPage with _$MessagesPage {
  const factory MessagesPage({
    @Default(<ChatMessage>[]) List<ChatMessage> messages,

    /// `hasMore` — older messages exist.
    @Default(false) bool hasMore,
  }) = _MessagesPage;
}
