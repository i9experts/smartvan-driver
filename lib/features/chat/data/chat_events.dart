import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/config/app_config.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_store.dart';
import 'models/chat_message.dart';

/// Something that happened in a chat while a chat screen was listening.
sealed class ChatEvent {
  const ChatEvent();
}

/// The other side sent a message (socket event `chatMessage`).
class ChatMessageReceived extends ChatEvent {
  const ChatMessageReceived(this.message);
  final ChatMessage message;
}

/// The other side read the conversation (socket event `chatRead`).
class ChatConversationRead extends ChatEvent {
  const ChatConversationRead(this.conversationId);
  final String conversationId;
}

/// Live chat events over Socket.IO. The server puts every socket in a
/// personal room, so nothing is joined and nothing is emitted. The socket
/// lives as long as something listens to this provider.
final chatEventsProvider = StreamProvider.autoDispose<ChatEvent>((ref) {
  final controller = StreamController<ChatEvent>();
  io.Socket? socket;

  ref.onDispose(() {
    socket?.dispose();
    socket = null;
    controller.close();
  });

  Future<void> connect() async {
    final token = await ref.read(tokenStorageProvider).read() ?? '';
    if (controller.isClosed) return;
    final config = ref.read(appConfigProvider);
    final s = ref.read(socketFactoryProvider)(
      config.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({'token': token})
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );
    s.on('chatMessage', (data) {
      if (data is Map && !controller.isClosed) {
        controller.add(ChatMessageReceived(
            ChatMessage.fromJson(Map<String, dynamic>.from(data))));
      }
    });
    s.on('chatRead', (data) {
      final id = data is Map ? looseString(data['conversationId']) : null;
      if (id != null && !controller.isClosed) {
        controller.add(ChatConversationRead(id));
      }
    });
    s.connect();
    socket = s;
  }

  unawaited(connect());
  return controller.stream;
});
