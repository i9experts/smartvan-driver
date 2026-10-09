import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/chat_providers.dart';
import '../../application/chat_thread.dart';
import '../../data/models/conversation.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

/// One conversation. [conversationId] comes from the route; [conversation]
/// is an optional already-loaded copy used for the header.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen(
      {super.key, required this.conversationId, this.conversation});

  final String conversationId;
  final Conversation? conversation;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  static const _navy = Color(0xFF1B3B69);
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send(String text, {String? templateKey}) async {
    final l10n = context.l10n;
    try {
      final sent = await ref
          .read(chatThreadProvider(widget.conversationId).notifier)
          .send(text, templateKey: templateKey);
      if (sent && templateKey == null) _input.clear();
    } catch (e) {
      if (mounted) {
        AppSnack.info(
            context, errorText(l10n, e, fallback: l10n.chatSendFailed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final threadAsync = ref.watch(chatThreadProvider(widget.conversationId));
    final conversation = widget.conversation ??
        ref.watch(conversationByIdProvider(widget.conversationId)).valueOrNull;

    ref.listen(chatThreadProvider(widget.conversationId), (_, next) {
      if (next.hasError && !next.hasValue) {
        AppSnack.info(context,
            errorText(l10n, next.error!, fallback: l10n.chatLoadFailed));
      }
    });

    final thread = threadAsync.valueOrNull;
    final Widget list;
    if (thread != null) {
      list = NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 100) {
            ref
                .read(chatThreadProvider(widget.conversationId).notifier)
                .loadMore();
          }
          return false;
        },
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(12),
          itemCount: thread.messages.length + (thread.loadingMore ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= thread.messages.length) {
              return const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            return ChatBubble(message: thread.messages[i]);
          },
        ),
      );
    } else if (threadAsync.hasError) {
      // A failed first load leaves an empty thread (the reason is shown).
      list = const SizedBox.expand();
    } else {
      list = const AppLoading();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conversation?.otherUser.name ?? '',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
            if (conversation != null && conversation.kidNames.isNotEmpty)
              Text(conversation.kidNames.join(', '),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: list),
          QuickRepliesBar(
            enabled: !(thread?.sending ?? false),
            onPick: (r) => _send(r.text, templateKey: r.key),
          ),
          ChatComposer(
            controller: _input,
            sending: thread?.sending ?? false,
            onSend: () => _send(_input.text),
          ),
        ],
      ),
    );
  }
}
