import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/chat/application/chat_providers.dart';
import 'package:smartvan_driver/features/chat/application/chat_thread.dart';
import 'package:smartvan_driver/features/chat/data/chat_events.dart';
import 'package:smartvan_driver/features/chat/data/chat_repository.dart';
import 'package:smartvan_driver/features/chat/data/models/chat_message.dart';
import 'package:smartvan_driver/features/chat/data/models/conversation.dart';
import 'package:smartvan_driver/features/chat/data/models/messages_page.dart';
import 'package:smartvan_driver/features/chat/presentation/screens/chat_screen.dart';
import 'package:smartvan_driver/features/chat/presentation/screens/conversations_screen.dart';

import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeChatRepo extends Mock implements ChatRepository {}

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  late _FakeChatRepo repo;
  late StreamController<ChatEvent> events;
  late List<Conversation> conversations;
  late MessagesPage firstPage;
  final f = fixtureMap('chat/chat.json');

  ChatMessage msg(String id, String sender, String text,
          {DateTime? at, DateTime? readAt}) =>
      ChatMessage(
          id: id,
          conversationId: 'conv-001',
          senderType: sender,
          text: text,
          createdAt: at ?? DateTime(2026, 10, 6, 8, 15),
          readAt: readAt);

  setUp(() {
    repo = _FakeChatRepo();
    events = StreamController<ChatEvent>.broadcast();
    addTearDown(events.close);
    // No avatar URLs: tests have no network.
    conversations = asJsonList(unwrapData(f['conversations']))
        .map(Conversation.fromJson)
        .map((c) => c.copyWith(otherUser: c.otherUser.copyWith(image: null)))
        .toList();
    firstPage = MessagesPage(
      messages: [msg('m-2', 'parent', 'ok'), msg('m-1', 'driver', 'Hello')],
      hasMore: true,
    );
    when(() => repo.conversations()).thenAnswer((_) async => conversations);
    when(() => repo.messages('conv-001', before: any(named: 'before')))
        .thenAnswer((_) async => firstPage);
    when(() => repo.markRead(any())).thenAnswer((_) async {});
  });

  List<Override> overrides() => [
        chatRepositoryProvider.overrideWithValue(repo),
        chatEventsProvider.overrideWith((ref) => events.stream),
      ];

  ProviderContainer container() {
    final c = ProviderContainer(overrides: overrides());
    addTearDown(c.dispose);
    return c;
  }

  group('conversations providers', () {
    test('conversations loads, conversationById finds one', () async {
      final c = container();
      expect((await c.read(conversationsProvider.future)).length, 3);
      expect(
          (await c.read(conversationByIdProvider('conv-002').future))
              ?.otherUser
              .name,
          'Another Parent');
      expect(await c.read(conversationByIdProvider('nope').future), isNull);
    });
  });

  group('ChatThread', () {
    test('loads the newest page and marks the conversation read', () async {
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      final s = await c.read(chatThreadProvider('conv-001').future);
      expect(s.messages.map((m) => m.id), ['m-2', 'm-1']);
      expect(s.hasMore, isTrue);
      verify(() => repo.markRead('conv-001')).called(1);
    });

    test('a failed first load is an error state', () async {
      when(() => repo.messages('conv-001', before: any(named: 'before')))
          .thenAnswer((_) async => throw const NetworkException());
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await expectLater(c.read(chatThreadProvider('conv-001').future),
          throwsA(isA<NetworkException>()));
    });

    test(
        'loadMore pages back with before = the oldest message and de-duplicates',
        () async {
      final older = MessagesPage(
          messages: [msg('m-1', 'driver', 'Hello'), msg('m-0', 'parent', 'Hi')],
          hasMore: false);
      when(() =>
              repo.messages('conv-001', before: DateTime(2026, 10, 6, 8, 15)))
          .thenAnswer((_) async => older);
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      await c.read(chatThreadProvider('conv-001').notifier).loadMore();
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages.map((m) => m.id), ['m-2', 'm-1', 'm-0']);
      expect(s.hasMore, isFalse);
      expect(s.loadingMore, isFalse);
      // Nothing more to load: no further request.
      await c.read(chatThreadProvider('conv-001').notifier).loadMore();
      verify(() =>
              repo.messages('conv-001', before: DateTime(2026, 10, 6, 8, 15)))
          .called(1);
    });

    test('a failed loadMore keeps what is on screen', () async {
      when(() =>
              repo.messages('conv-001', before: DateTime(2026, 10, 6, 8, 15)))
          .thenAnswer((_) async => throw const NetworkException());
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      await c.read(chatThreadProvider('conv-001').notifier).loadMore();
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages, hasLength(2));
      expect(s.loadingMore, isFalse);
    });

    test('send adds the sent message once and clears the flag', () async {
      final sent = msg('m-3', 'driver', 'On my way');
      when(() => repo.send('conv-001', 'On my way', templateKey: null))
          .thenAnswer((_) async => sent);
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      final ok = await c
          .read(chatThreadProvider('conv-001').notifier)
          .send('  On my way ');
      expect(ok, isTrue);
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages.first.id, 'm-3');
      expect(s.sending, isFalse);
    });

    test('a quick reply sends its template key', () async {
      when(() => repo.send('conv-001', 'Arriving in 5 minutes.',
              templateKey: 'arriving_5'))
          .thenAnswer(
              (_) async => msg('m-4', 'driver', 'Arriving in 5 minutes.'));
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      await c
          .read(chatThreadProvider('conv-001').notifier)
          .send('Arriving in 5 minutes.', templateKey: 'arriving_5');
      verify(() => repo.send('conv-001', 'Arriving in 5 minutes.',
          templateKey: 'arriving_5')).called(1);
    });

    test('blank text is not sent', () async {
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      expect(await c.read(chatThreadProvider('conv-001').notifier).send('   '),
          isFalse);
      verifyNever(() =>
          repo.send(any(), any(), templateKey: any(named: 'templateKey')));
    });

    test('a failed send rethrows and clears the sending flag', () async {
      when(() => repo.send('conv-001', 'x', templateKey: null))
          .thenThrow(const NetworkException());
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      await expectLater(
          c.read(chatThreadProvider('conv-001').notifier).send('x'),
          throwsA(isA<NetworkException>()));
      expect(
          c.read(chatThreadProvider('conv-001')).requireValue.sending, isFalse);
    });

    test('socket: a parent message is added once and marked read', () async {
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      clearInteractions(repo);
      final incoming = msg('m-5', 'parent', 'Thanks');
      events.add(ChatMessageReceived(incoming));
      events.add(ChatMessageReceived(incoming)); // duplicate
      await pumpEventQueue();
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages.where((m) => m.id == 'm-5'), hasLength(1));
      expect(s.messages.first.id, 'm-5');
      verify(() => repo.markRead('conv-001')).called(1);
    });

    test('socket: another conversation and my own echo are handled', () async {
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      clearInteractions(repo);
      events.add(ChatMessageReceived(msg('x', 'parent', 'elsewhere')
          .copyWith(conversationId: 'conv-999')));
      events.add(
          ChatMessageReceived(msg('m-6', 'driver', 'from another device')));
      await pumpEventQueue();
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages.map((m) => m.id), ['m-6', 'm-2', 'm-1']);
      verifyNever(
          () => repo.markRead(any())); // my own message needs no read receipt
    });

    test('socket: chatRead marks my unread messages read', () async {
      final c = container();
      final sub = c.listen(chatThreadProvider('conv-001'), (_, __) {});
      addTearDown(sub.close);
      await c.read(chatThreadProvider('conv-001').future);
      events.add(const ChatConversationRead('conv-999'));
      await pumpEventQueue();
      expect(
          c
              .read(chatThreadProvider('conv-001'))
              .requireValue
              .messages
              .every((m) => m.readAt == null),
          isTrue);
      events.add(const ChatConversationRead('conv-001'));
      await pumpEventQueue();
      final s = c.read(chatThreadProvider('conv-001')).requireValue;
      expect(s.messages.firstWhere((m) => m.id == 'm-1').readAt,
          isNotNull); // mine
      expect(
          s.messages.firstWhere((m) => m.id == 'm-2').readAt, isNull); // theirs
    });
  });

  Widget app(Widget home, {String initial = '/chats'}) => routerHost(
        {
          '/chats': (_) => const ConversationsScreen(),
          '/chat/:conversationId': (s) => ChatScreen(
              conversationId: s.pathParameters['conversationId']!,
              conversation:
                  s.extra is Conversation ? s.extra as Conversation : null),
        },
        initial: initial,
        overrides: overrides(),
      );

  group('ConversationsScreen', () {
    testWidgets('lists conversations with kids, last text, unread badge',
        (tester) async {
      useTallView(tester);
      await tester.pumpWidget(app(const ConversationsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Test Parent'), findsOneWidget);
      expect(find.text('Test Kid One, Test Kid Two ·   On my way  '),
          findsOneWidget);
      expect(find.text('2'), findsOneWidget); // unread badge
      expect(find.text('Another Parent'), findsOneWidget);
    });

    testWidgets('empty state', (tester) async {
      conversations = [];
      await tester.pumpWidget(app(const ConversationsScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('No messages yet.'), findsOneWidget);
    });

    testWidgets('load error', (tester) async {
      when(() => repo.conversations())
          .thenAnswer((_) async => throw const NetworkException());
      await tester.pumpWidget(app(const ConversationsScreen()));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
    });

    testWidgets('a socket message reloads the list quietly', (tester) async {
      await tester.pumpWidget(app(const ConversationsScreen()));
      await tester.pumpAndSettle();
      verify(() => repo.conversations()).called(1);
      events.add(ChatMessageReceived(msg('m-9', 'parent', 'new')));
      await tester.pumpAndSettle();
      verify(() => repo.conversations()).called(1);
      expect(find.text('Test Parent'), findsOneWidget); // never blanked
    });

    testWidgets('tapping a conversation opens /chat/<id>', (tester) async {
      await tester.pumpWidget(app(const ConversationsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Parent'));
      await tester.pumpAndSettle();
      expect(find.text('Type a message'), findsOneWidget);
      verify(() => repo.messages('conv-001', before: null)).called(1);
    });
  });

  group('ChatScreen', () {
    testWidgets('shows header, bubbles and quick replies', (tester) async {
      useTallView(tester);
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      expect(find.text('Test Parent'),
          findsOneWidget); // header via the loaded list
      expect(find.text('Test Kid One, Test Kid Two'), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Arriving in 5 minutes.'), findsOneWidget);
      expect(find.text('Type a message'), findsOneWidget);
    });

    testWidgets(
        'typing and sending clears the field; double ticks show read state',
        (tester) async {
      when(() => repo.send('conv-001', 'On my way', templateKey: null))
          .thenAnswer((_) async => msg('m-3', 'driver', 'On my way'));
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'On my way');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      verify(() => repo.send('conv-001', 'On my way', templateKey: null))
          .called(1);
      expect(find.text('On my way'), findsOneWidget); // bubble; field cleared
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
          '');
      expect(find.byIcon(Icons.done), findsWidgets);
    });

    testWidgets('a quick reply sends with its key and leaves the field alone',
        (tester) async {
      when(() => repo.send('conv-001', 'I am at the pickup point.',
              templateKey: 'at_pickup'))
          .thenAnswer(
              (_) async => msg('m-7', 'driver', 'I am at the pickup point.'));
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'draft');
      await tester.tap(find.text('I am at the pickup point.'));
      await tester.pumpAndSettle();
      verify(() => repo.send('conv-001', 'I am at the pickup point.',
          templateKey: 'at_pickup')).called(1);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'draft');
    });

    testWidgets('a failed send shows why', (tester) async {
      when(() =>
              repo.send(any(), any(), templateKey: any(named: 'templateKey')))
          .thenThrow(
              const ApiError(status: 400, message: 'Conversation closed'));
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'x');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      expect(find.text('Conversation closed'), findsOneWidget);
    });

    testWidgets('a message arriving over the socket appears', (tester) async {
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      events.add(ChatMessageReceived(msg('m-8', 'parent', 'Running late')));
      await tester.pumpAndSettle();
      expect(find.text('Running late'), findsOneWidget);
    });

    testWidgets('first load failure shows the reason', (tester) async {
      when(() => repo.messages('conv-001', before: any(named: 'before')))
          .thenAnswer((_) async => throw const NetworkException());
      await tester.pumpWidget(
          app(const ConversationsScreen(), initial: '/chat/conv-001'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
    });
  });
}
