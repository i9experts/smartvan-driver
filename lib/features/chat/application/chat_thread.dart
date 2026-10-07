import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../chat_templates.dart';
import '../data/chat_events.dart';
import '../data/chat_repository.dart';
import 'chat_providers.dart';
import 'chat_thread_state.dart';

part 'chat_thread.g.dart';

/// One open conversation: loads the newest page, pages back, sends, and
/// applies live socket events (new messages, read receipts).
@riverpod
class ChatThread extends _$ChatThread {
  @override
  Future<ChatThreadState> build(String conversationId) async {
    // Live events for this conversation while it is open.
    ref.listen(chatEventsProvider, (_, next) => next.whenData(_onEvent));

    final repo = ref.watch(chatRepositoryProvider);
    final page = await repo.messages(conversationId);
    // Opening the chat counts as reading it; failing to say so is harmless.
    repo.markRead(conversationId).ignore();
    return ChatThreadState(messages: page.messages, hasMore: page.hasMore);
  }

  ChatThreadState? get _current => state.valueOrNull;

  void _onEvent(ChatEvent event) {
    final current = _current;
    if (current == null) return;
    switch (event) {
      case ChatMessageReceived(:final message):
        if (message.conversationId != conversationId) return;
        if (current.messages.any((m) => m.id == message.id)) return;
        state = AsyncData(
            current.copyWith(messages: [message, ...current.messages]));
        if (message.senderType != myChatRole) {
          ref.read(chatRepositoryProvider).markRead(conversationId).ignore();
        }
      case ChatConversationRead(:final conversationId):
        if (conversationId != this.conversationId) return;
        final now = DateTime.now();
        state = AsyncData(current.copyWith(messages: [
          for (final m in current.messages)
            m.senderType == myChatRole && m.readAt == null
                ? m.copyWith(readAt: now)
                : m,
        ]));
    }
  }

  /// Loads the next older page. Failures are ignored: the driver keeps what
  /// is already on screen.
  Future<void> loadMore() async {
    final current = _current;
    if (current == null ||
        current.loadingMore ||
        !current.hasMore ||
        current.messages.isEmpty) {
      return;
    }
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref
          .read(chatRepositoryProvider)
          .messages(conversationId, before: current.messages.last.createdAt);
      final latest = _current ?? current;
      state = AsyncData(latest.copyWith(
        messages: [
          ...latest.messages,
          ...page.messages
              .where((m) => !latest.messages.any((x) => x.id == m.id)),
        ],
        hasMore: page.hasMore,
        loadingMore: false,
      ));
    } catch (_) {
      state = AsyncData((_current ?? current).copyWith(loadingMore: false));
    }
  }

  /// Sends [text] (a quick reply passes its [templateKey]). Returns true when
  /// it was sent; throws the `AppException` otherwise (after clearing the
  /// sending flag) so the screen can say why.
  Future<bool> send(String text, {String? templateKey}) async {
    final t = text.trim();
    final current = _current;
    if (t.isEmpty || current == null || current.sending) return false;
    state = AsyncData(current.copyWith(sending: true));
    try {
      final sent = await ref
          .read(chatRepositoryProvider)
          .send(conversationId, t, templateKey: templateKey);
      final latest = _current ?? current;
      state = AsyncData(latest.copyWith(
        sending: false,
        messages: latest.messages.any((m) => m.id == sent.id)
            ? latest.messages
            : [sent, ...latest.messages],
      ));
      ref.invalidate(conversationsProvider);
      return true;
    } catch (_) {
      state = AsyncData((_current ?? current).copyWith(sending: false));
      rethrow;
    }
  }
}
