import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/chat/data/models/chat_message.dart';
import 'package:smartvan_driver/features/chat/data/models/chat_user.dart';
import 'package:smartvan_driver/features/chat/data/models/conversation.dart';

import '../../../../support/fixture.dart';

void main() {
  final f = fixtureMap('chat/chat.json');

  group('Conversation', () {
    final list = asJsonList(unwrapData(f['conversations']))
        .map(Conversation.fromJson)
        .toList();

    test('full conversation', () {
      final c = list[0];
      expect(c.id, 'conv-001');
      expect(c.otherUser.id, 'parent-001');
      expect(c.otherUser.type, 'parent');
      expect(c.otherUser.name, 'Test Parent');
      expect(c.otherUser.image, 'https://example.test/img/p1.png');
      expect(
          c.kidNames, ['Test Kid One', 'Test Kid Two']); // blank names dropped
      expect(c.lastText, '  On my way  '); // not trimmed
      expect(c.lastSenderType, 'parent');
      expect(c.lastAt, DateTime.utc(2026, 10, 6, 8, 15).toLocal());
      expect(c.lastAt!.isUtc, isFalse);
      expect(c.unread, 2);
    });

    test('no last message, unread as string', () {
      final c = list[1];
      expect(c.lastText, isNull);
      expect(c.lastAt, isNull);
      expect(c.kidNames, isEmpty);
      expect(c.otherUser.image, isNull);
      expect(c.unread, 3);
    });

    test('bare conversation gets defaults', () {
      final c = list[2];
      expect(c.id, 'conv-003');
      expect(c.otherUser, const ChatUser());
      expect(c.kidNames, isEmpty);
      expect(c.unread, 0);
    });

    test('POST /chat/start answer', () {
      final c = Conversation.fromJson(asJsonMap(unwrapData(f['start'])));
      expect(c.id, 'conv-004');
      expect(c.otherUser.name, 'Fourth Parent');
      expect(c.kidNames, ['Test Kid Four']);
    });
  });

  test('unread count shape', () {
    expect(looseInt(asJsonMap(unwrapData(f['unread']))['unread']), 5);
  });

  group('ChatMessage', () {
    final body = asJsonMap(f['messages']);
    final list = asJsonList(body['data']).map(ChatMessage.fromJson).toList();

    test('REST list, newest first, hasMore sibling', () {
      expect(body['hasMore'], isTrue);
      expect(list.map((m) => m.id), ['m-3', 'm-2', 'm-1']);
      expect(list[0].senderType, 'driver');
      expect(list[0].text, 'Arriving in 5 minutes');
      expect(list[0].conversationId, 'conv-001');
      expect(list[0].createdAt, DateTime.utc(2026, 10, 6, 8, 20).toLocal());
      expect(list[0].readAt, DateTime.utc(2026, 10, 6, 8, 21).toLocal());
      expect(list[0].pending, isFalse);
    });

    test('text keeps its whitespace; unread has no readAt', () {
      expect(list[1].text, ' ok ');
      expect(list[1].readAt, isNull);
    });

    test('a broken timestamp becomes "now"', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      expect(list[2].createdAt.isAfter(before), isTrue);
    });

    test('socket event has the same shape', () {
      final m = ChatMessage.fromJson(asJsonMap(f['socketMessage']));
      expect(m.id, 'm-4');
      expect(m.text, 'Thanks');
    });

    test('pending is local only', () {
      final m = ChatMessage.fromJson({'messageId': 'x', 'pending': true});
      expect(m.pending, isFalse);
      expect(
          m.copyWith(pending: true).toJson().containsKey('pending'), isFalse);
    });

    test('copyWith(readAt) marks a message read', () {
      final read = list[1].copyWith(readAt: DateTime(2026, 10, 6, 9));
      expect(read.readAt, DateTime(2026, 10, 6, 9));
      expect(read.id, list[1].id);
      expect(read.text, list[1].text);
    });
  });
}
