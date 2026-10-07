import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/chat_message.dart';

part 'chat_thread_state.freezed.dart';

/// Everything a chat screen shows about one conversation.
@freezed
abstract class ChatThreadState with _$ChatThreadState {
  const factory ChatThreadState({
    /// Newest first.
    @Default(<ChatMessage>[]) List<ChatMessage> messages,

    /// Older messages exist on the server.
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    @Default(false) bool sending,
  }) = _ChatThreadState;
}
