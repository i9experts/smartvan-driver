import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/config/app_config.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';
import 'package:smartvan_driver/features/chat/data/chat_events.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../support/fixture.dart';

class _FakeSocket extends Mock implements io.Socket {}

class _FakeTokens extends Mock implements TokenStore {}

void main() {
  setUpAll(() => registerFallbackValue((dynamic _) {}));

  late _FakeSocket socket;
  late Map<String, dynamic Function(dynamic)> handlers;
  late List<(String, Map<String, dynamic>)> created;
  late ProviderContainer container;
  late List<ChatEvent> events;

  setUp(() {
    socket = _FakeSocket();
    handlers = {};
    created = [];
    events = [];
    when(() => socket.on(any(), any())).thenAnswer((inv) {
      handlers[inv.positionalArguments[0] as String] =
          inv.positionalArguments[1] as dynamic Function(dynamic);
    });
    when(() => socket.connect()).thenReturn(socket);
    when(() => socket.dispose()).thenReturn(null);

    final tokens = _FakeTokens();
    when(() => tokens.read()).thenAnswer((_) async => 'fake-jwt');

    container = ProviderContainer(overrides: [
      appConfigProvider.overrideWithValue(const AppConfig(
          apiBaseUrl: 'http://api.test', socketUrl: 'http://socket.test')),
      tokenStorageProvider.overrideWithValue(tokens),
      socketFactoryProvider.overrideWithValue((url, options) {
        created.add((url, options));
        return socket;
      }),
    ]);
    addTearDown(container.dispose);
  });

  Future<void> start() async {
    container.listen<AsyncValue<ChatEvent>>(chatEventsProvider, (_, next) {
      next.whenData(events.add);
    });
    await pumpEventQueue();
  }

  test('connects to the socket URL with the token and websocket/polling',
      () async {
    await start();
    expect(created, hasLength(1));
    expect(created.single.$1, 'http://socket.test');
    final opts = created.single.$2;
    expect(opts['auth'], {'token': 'fake-jwt'});
    expect(opts['transports'], ['websocket', 'polling']);
    expect(opts['autoConnect'], isFalse);
    verify(() => socket.connect()).called(1);
    expect(handlers.keys, containsAll(['chatMessage', 'chatRead']));
  });

  test('chatMessage becomes ChatMessageReceived', () async {
    await start();
    handlers['chatMessage']!(fixtureMap('chat/chat.json')['socketMessage']);
    await pumpEventQueue();
    final e = events.single as ChatMessageReceived;
    expect(e.message.id, 'm-4');
    expect(e.message.text, 'Thanks');
  });

  test('chatRead becomes ChatConversationRead', () async {
    await start();
    handlers['chatRead']!({'conversationId': 'conv-001'});
    await pumpEventQueue();
    expect((events.single as ChatConversationRead).conversationId, 'conv-001');
  });

  test('malformed payloads are ignored', () async {
    await start();
    handlers['chatMessage']!('nonsense');
    handlers['chatRead']!({'other': 1});
    handlers['chatRead']!(null);
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('disposing the provider disposes the socket', () async {
    await start();
    container.dispose();
    verify(() => socket.dispose()).called(1);
  });

  test('disposed before the token arrives: no socket is created', () async {
    final sub = container.listen(chatEventsProvider, (_, __) {});
    sub.close();
    container.dispose();
    await pumpEventQueue();
    expect(created, isEmpty);
  });
}
