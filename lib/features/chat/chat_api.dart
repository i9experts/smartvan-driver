import '../../core/network/api_service.dart';
import 'data/models/chat_message.dart';
import 'data/models/conversation.dart';

export 'data/models/chat_message.dart';
export 'data/models/chat_user.dart';
export 'data/models/conversation.dart';

class ChatApi {
  ChatApi._();

  static Conversation _conversation(Map m) =>
      Conversation.fromJson(Map<String, dynamic>.from(m));

  static ChatMessage _message(Map m) =>
      ChatMessage.fromJson(Map<String, dynamic>.from(m));

  static Map _data(dynamic body) =>
      body is Map && body['data'] is Map ? body['data'] as Map : const {};

  static Future<List<Conversation>> conversations() async {
    final res = await ApiService.get('/chat/conversations');
    final d = res.data is Map ? res.data['data'] : null;
    return d is List ? d.whereType<Map>().map(_conversation).toList() : [];
  }

  static Future<int> unread() async {
    final res = await ApiService.get('/chat/unread');
    return (_data(res.data)['unread'] as num?)?.toInt() ?? 0;
  }

  static Future<Conversation> start(String kidId) async {
    final res = await ApiService.post('/chat/start', {'kidId': kidId});
    return _conversation(_data(res.data));
  }

  /// Newest first.
  static Future<(List<ChatMessage>, bool)> messages(String conversationId,
      {DateTime? before}) async {
    final q = before == null
        ? ''
        : '?before=${Uri.encodeComponent(before.toUtc().toIso8601String())}';
    final res = await ApiService.get('/chat/$conversationId/messages$q');
    final body = res.data is Map ? res.data as Map : const {};
    final d = body['data'];
    final list =
        d is List ? d.whereType<Map>().map(_message).toList() : <ChatMessage>[];
    return (list, body['hasMore'] == true);
  }

  static Future<ChatMessage> send(String conversationId, String text,
      {String? templateKey}) async {
    final res = await ApiService.post('/chat/$conversationId/messages', {
      'text': text,
      if (templateKey != null) 'templateKey': templateKey,
    });
    return _message(_data(res.data));
  }

  static Future<void> markRead(String conversationId) async {
    await ApiService.post('/chat/$conversationId/read', {});
  }
}
