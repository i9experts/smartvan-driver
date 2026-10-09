import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../chat_templates.dart';
import '../../data/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1B3B69);
    final m = message;
    final mine = m.senderType == myChatRole;
    final locale = Localizations.localeOf(context).toString();
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: mine ? navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(mine ? 14 : 2),
            bottomRight: Radius.circular(mine ? 2 : 14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(m.text,
                style: TextStyle(
                    color: mine ? Colors.white : const Color(0xFF1A1A2E),
                    fontFamily: 'Poppins')),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('h:mm a', locale).format(m.createdAt),
                    style: TextStyle(
                        fontSize: 10,
                        color:
                            mine ? Colors.white70 : const Color(0xFF8A94A6))),
                if (mine) ...[
                  const SizedBox(width: 4),
                  Icon(m.readAt != null ? Icons.done_all : Icons.done,
                      size: 14,
                      color: m.readAt != null
                          ? const Color(0xFF7FD3FF)
                          : Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
