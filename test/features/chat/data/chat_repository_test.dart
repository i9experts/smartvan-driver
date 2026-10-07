import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/chat/data/chat_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late ChatRepository repo;
  final f = fixtureMap('chat/chat.json');

  setUp(() {
    env = ApiTestEnv();
    repo = ChatRepository(env.client);
  });

  test('conversations GETs /chat/conversations', () async {
    env.adapter
        .onGet('/chat/conversations', (s) => s.reply(200, f['conversations']));
    final list = await repo.conversations();
    expect(list.map((c) => c.id), ['conv-001', 'conv-002', 'conv-003']);
    expect(list.first.unread, 2);
  });

  test('unread GETs /chat/unread and reads data.unread', () async {
    env.adapter.onGet('/chat/unread', (s) => s.reply(200, f['unread']));
    expect(await repo.unread(), 5);
  });

  test('start POSTs the kidId and returns the conversation', () async {
    env.adapter.onPost('/chat/start', (s) => s.reply(201, f['start']),
        data: {'kidId': 'kid-004'});
    final c = await repo.start('kid-004');
    expect(c.id, 'conv-004');
    expect(c.kidNames, ['Test Kid Four']);
  });

  group('messages', () {
    test('first page: no query, hasMore from the body next to data', () async {
      env.adapter
          .onGet('/chat/conv-001/messages', (s) => s.reply(200, f['messages']));
      final page = await repo.messages('conv-001');
      expect(page.messages.map((m) => m.id), ['m-3', 'm-2', 'm-1']);
      expect(page.hasMore, isTrue);
    });

    test('next page sends ?before= as a UTC ISO string', () async {
      final before = DateTime.utc(2026, 10, 6, 8, 15);
      env.adapter.onGet('/chat/conv-001/messages',
          (s) => s.reply(200, {'data': [], 'hasMore': false}),
          queryParameters: {'before': '2026-10-06T08:15:00.000Z'});
      final page = await repo.messages('conv-001', before: before);
      expect(page.messages, isEmpty);
      expect(page.hasMore, isFalse);
    });

    test('a local DateTime is converted to UTC', () async {
      final local = DateTime.utc(2026, 10, 6, 8, 15).toLocal();
      env.adapter.onGet(
          '/chat/conv-001/messages', (s) => s.reply(200, {'data': []}),
          queryParameters: {'before': '2026-10-06T08:15:00.000Z'});
      expect((await repo.messages('conv-001', before: local)).hasMore, isFalse);
    });

    test('403 for someone else\'s conversation is an ApiError', () async {
      env.adapter.onGet('/chat/other/messages',
          (s) => s.reply(403, {'message': 'Forbidden'}));
      await expectLater(repo.messages('other'),
          throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)));
    });
  });

  group('send', () {
    test('POSTs text only for a typed message', () async {
      env.adapter.onPost('/chat/conv-001/messages',
          (s) => s.reply(201, {'data': f['socketMessage']}),
          data: {'text': 'Thanks'});
      expect((await repo.send('conv-001', 'Thanks')).id, 'm-4');
    });

    test('adds templateKey for a quick reply', () async {
      env.adapter.onPost('/chat/conv-001/messages',
          (s) => s.reply(201, {'data': f['socketMessage']}), data: {
        'text': 'Arriving in 5 minutes.',
        'templateKey': 'arriving_5'
      });
      await repo.send('conv-001', 'Arriving in 5 minutes.',
          templateKey: 'arriving_5');
    });

    test('offline: NetworkException', () async {
      env.adapter.onPost('/chat/conv-001/messages',
          (s) => s.throws(0, connectionError('/chat/conv-001/messages')),
          data: Matchers.any);
      await expectLater(
          repo.send('conv-001', 'x'), throwsA(isA<NetworkException>()));
    });
  });

  test('markRead POSTs an empty body to /chat/{id}/read', () async {
    env.adapter.onPost(
        '/chat/conv-001/read', (s) => s.reply(200, {'success': true}),
        data: <String, dynamic>{});
    await repo.markRead('conv-001');
  });
}
