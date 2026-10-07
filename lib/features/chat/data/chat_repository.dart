import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/chat_message.dart';
import 'models/conversation.dart';
import 'models/messages_page.dart';

/// Chat over REST. Live events come from [chatEventsProvider].
class ChatRepository {
  const ChatRepository(this._api);

  final ApiClient _api;

  /// `GET /chat/conversations`.
  Future<List<Conversation>> conversations() => _api.get(
        '/chat/conversations',
        (json) => asJsonList(json).map(Conversation.fromJson).toList(),
      );

  /// `GET /chat/unread` — total unread messages (for the badge).
  Future<int> unread() => _api.get(
        '/chat/unread',
        (json) => json is Map ? looseInt(json['unread']) ?? 0 : 0,
      );

  /// `POST /chat/start` — opens (or returns) the conversation about a kid.
  Future<Conversation> start(String kidId) => _api.post(
        '/chat/start',
        (json) => Conversation.fromJson(asJsonMap(json)),
        body: {'kidId': kidId},
      );

  /// `GET /chat/{id}/messages[?before=ISO]` — newest first. Pass the oldest
  /// message's `createdAt` as [before] to load the next page.
  Future<MessagesPage> messages(String conversationId, {DateTime? before}) =>
      _api.getEnvelope(
        '/chat/$conversationId/messages',
        (e) => MessagesPage(
          messages: asJsonList(e.data).map(ChatMessage.fromJson).toList(),
          hasMore: e['hasMore'] == true,
        ),
        query: before == null
            ? null
            : {'before': before.toUtc().toIso8601String()},
      );

  /// `POST /chat/{id}/messages`. [templateKey] marks a quick reply.
  Future<ChatMessage> send(
    String conversationId,
    String text, {
    String? templateKey,
  }) =>
      _api.post(
        '/chat/$conversationId/messages',
        (json) => ChatMessage.fromJson(asJsonMap(json)),
        body: {
          'text': text,
          if (templateKey != null) 'templateKey': templateKey,
        },
      );

  /// `POST /chat/{id}/read`.
  Future<void> markRead(String conversationId) =>
      _api.post<void>('/chat/$conversationId/read', (_) {}, body: {});
}

final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepository(ref.watch(apiClientProvider)));
