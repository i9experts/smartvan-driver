import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/chat_providers.dart';
import '../../data/chat_events.dart';
import '../../data/models/conversation.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  static const _navy = Color(0xFF1B3B69);

  String _time(DateTime? t, String locale) {
    if (t == null) return '';
    final now = DateTime.now();
    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return DateFormat('h:mm a', locale).format(t);
    }
    return DateFormat('d MMM', locale).format(t);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final itemsAsync = ref.watch(conversationsProvider);

    // A new message anywhere: reload the list quietly (the old list stays).
    ref.listen(chatEventsProvider, (_, next) {
      if (next.valueOrNull is ChatMessageReceived) {
        ref.invalidate(conversationsProvider);
      }
    });

    final items = itemsAsync.valueOrNull;
    final Widget body;
    if (items == null && !itemsAsync.hasError) {
      body = const AppLoading();
    } else if (items == null || items.isEmpty) {
      body = ListView(
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.chat_bubble_outline,
              size: 48, color: Color(0xFF8A94A6)),
          const SizedBox(height: 12),
          Text(
            itemsAsync.hasError
                ? errorText(l10n, itemsAsync.error!,
                    fallback: l10n.chatLoadFailed)
                : l10n.chatEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
          ),
        ],
      );
    } else {
      body = ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) => _ConversationTile(
          conversation: items[i],
          time: _time(items[i].lastAt, locale),
          onTap: () async {
            await context.push(AppRoutes.chatOf(items[i].id), extra: items[i]);
            ref.invalidate(conversationsProvider);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(l10n.chatMessagesTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(conversationsProvider);
          try {
            await ref.read(conversationsProvider.future);
          } catch (_) {
            // The error shows in the list area.
          }
        },
        child: body,
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.time,
    required this.onTap,
  });

  final Conversation conversation;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final subtitle = c.kidNames.isEmpty ? '' : '${c.kidNames.join(', ')} · ';
    const navy = Color(0xFF1B3B69);
    return ListTile(
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: navy.withValues(alpha: 0.1),
        backgroundImage:
            c.otherUser.image != null ? NetworkImage(c.otherUser.image!) : null,
        child: c.otherUser.image == null
            ? Text(
                c.otherUser.name.isNotEmpty
                    ? c.otherUser.name[0].toUpperCase()
                    : '?',
                style:
                    const TextStyle(color: navy, fontWeight: FontWeight.bold))
            : null,
      ),
      title: Text(c.otherUser.name,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: c.unread > 0 ? FontWeight.bold : FontWeight.w500)),
      subtitle: Text('$subtitle${c.lastText ?? ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time,
              style: const TextStyle(fontSize: 11, color: Color(0xFF8A94A6))),
          if (c.unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${c.unread}',
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
