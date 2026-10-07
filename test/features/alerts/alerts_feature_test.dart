import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/alerts/application/alerts_provider.dart';
import 'package:smartvan_driver/features/alerts/application/send_alert_controller.dart';
import 'package:smartvan_driver/features/alerts/data/alerts_repository.dart';
import 'package:smartvan_driver/features/alerts/data/models/alert.dart';
import 'package:smartvan_driver/features/alerts/data/models/alert_type.dart';
import 'package:smartvan_driver/features/alerts/presentation/screens/alert_detail_screen.dart';
import 'package:smartvan_driver/features/alerts/presentation/screens/alerts_screen.dart';

import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeAlertsRepo extends Mock implements AlertsRepository {}

void main() {
  late _FakeAlertsRepo repo;
  late List<Alert> alerts;

  setUp(() {
    repo = _FakeAlertsRepo();
    alerts =
        Alert.listFrom(fixtureMap('alerts/alerts_shapes.json')['dataList']);
    when(() => repo.alerts()).thenAnswer((_) async => alerts);
  });

  List<Override> overrides() =>
      [alertsRepositoryProvider.overrideWithValue(repo)];

  group('controllers', () {
    test('alertsProvider loads from the repository', () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect((await c.read(alertsProvider.future)).length, 5);
    });

    test('alertsProvider surfaces failures', () async {
      when(() => repo.alerts())
          .thenAnswer((_) async => throw const NetworkException());
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      await expectLater(
          c.read(alertsProvider.future), throwsA(isA<NetworkException>()));
    });

    test(
        'SendAlertController returns true on success and false with the error otherwise',
        () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      when(() => repo.sendAlert('hello')).thenAnswer((_) async {});
      expect(await c.read(sendAlertControllerProvider.notifier).send('hello'),
          isTrue);

      when(() => repo.sendAlert('again'))
          .thenThrow(const ApiError(status: 400, message: 'Nope'));
      expect(await c.read(sendAlertControllerProvider.notifier).send('again'),
          isFalse);
      expect(
          (c.read(sendAlertControllerProvider).error as AppException)
              .userMessage,
          'Nope');
    });
  });

  Widget app(Widget home, {String path = '/alerts'}) => routerHost(
        {
          '/alerts': (_) => home,
          '/alerts/:alertId': (s) => AlertDetailScreen(
              alertId: s.pathParameters['alertId']!,
              alert: s.extra is Alert ? s.extra as Alert : null),
          '/home': (_) => const Text('home-stub'),
        },
        initial: path,
        overrides: overrides(),
      );

  group('AlertsScreen', () {
    testWidgets('lists alerts with title, body and relative time',
        (tester) async {
      alerts = [
        Alert(
            id: 'a1',
            type: AlertType.sos,
            title: 'SOS',
            message: 'Driver pressed SOS',
            createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
        Alert(
            id: 'a2',
            type: AlertType.payment,
            message: 'Fee received',
            createdAt: DateTime.now().subtract(const Duration(hours: 3))),
        Alert(
            id: 'a3',
            createdAt: DateTime.now().subtract(const Duration(days: 2))),
      ];
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Send Alert'), findsOneWidget);
      expect(find.text('SOS'), findsOneWidget);
      expect(find.text('Driver pressed SOS'), findsOneWidget);
      expect(find.text('5m ago'), findsOneWidget);
      expect(find.text('Fee received'),
          findsOneWidget); // message doubles as title
      expect(find.text('3h ago'), findsOneWidget);
      expect(find.text('Alert'), findsOneWidget); // no title, no message
      expect(find.text('2d ago'), findsOneWidget);
    });

    testWidgets('empty list', (tester) async {
      alerts = [];
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('No Alerts'), findsOneWidget);
      expect(find.text('No alerts at the moment'), findsOneWidget);
    });

    testWidgets('error with Retry', (tester) async {
      var fail = true;
      when(() => repo.alerts()).thenAnswer((_) async {
        if (fail) throw const NetworkException();
        return alerts;
      });
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Couldn't Load Alerts"), findsOneWidget);
      expect(find.text('Check your connection and try again'), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text("Couldn't Load Alerts"), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('tapping an alert opens /alerts/<id> with the alert',
        (tester) async {
      alerts = [
        Alert(
            id: 'a1',
            type: AlertType.payment,
            message: 'Fee received',
            createdAt: DateTime.now()),
      ];
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fee received'));
      await tester.pumpAndSettle();
      expect(find.text('Alert Details'), findsOneWidget);
      expect(
          find.text('Payment Alert'), findsOneWidget); // type heading, no title
      expect(find.text('Fee received'), findsOneWidget); // body
    });

    testWidgets('Send Alert: validates, sends, closes and confirms',
        (tester) async {
      when(() => repo.sendAlert(any())).thenAnswer((_) async {});
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send Alert'));
      await tester.pumpAndSettle();
      expect(
          find.text('Type a message for your school admin.'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Alert'));
      await tester.pump();
      expect(find.text('Type a message first.'), findsOneWidget);
      verifyNever(() => repo.sendAlert(any()));

      await tester.enterText(find.byType(TextFormField), '  Van is late  ');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Alert'));
      await tester.pumpAndSettle();
      verify(() => repo.sendAlert('Van is late')).called(1);
      expect(find.text('Type a message for your school admin.'), findsNothing);
      expect(find.text('Alert sent to your school admin!'), findsOneWidget);
    });

    testWidgets('Send Alert failure keeps the sheet and shows the reason',
        (tester) async {
      when(() => repo.sendAlert(any())).thenThrow(const NetworkException());
      await tester.pumpWidget(app(const AlertsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send Alert'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'x');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Alert'));
      await tester.pumpAndSettle();
      expect(
          find.text('Type a message for your school admin.'), findsOneWidget);
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
    });
  });

  group('AlertDetailScreen', () {
    testWidgets('without extra it finds the alert in the loaded list by id',
        (tester) async {
      alerts = [
        Alert(
            id: 'a1',
            type: AlertType.sos,
            message: 'Help needed',
            createdAt: DateTime(2026, 10, 6, 13, 5)),
      ];
      await tester.pumpWidget(app(const AlertsScreen(), path: '/alerts/a1'));
      await tester.pumpAndSettle();
      expect(find.text('Emergency Alert'), findsOneWidget);
      expect(find.text('Help needed'), findsOneWidget);
      expect(find.textContaining('01:05 PM'), findsOneWidget);
    });

    testWidgets('an unknown id says so', (tester) async {
      alerts = [const Alert(id: 'a1')];
      await tester
          .pumpWidget(app(const AlertsScreen(), path: '/alerts/missing'));
      await tester.pumpAndSettle();
      expect(find.text('Alert not found'), findsOneWidget);
    });

    testWidgets('trip details card and View Trip appear only with a tripId',
        (tester) async {
      alerts = [
        const Alert(
            id: 'a1',
            type: AlertType.trip,
            message: 'Trip assigned',
            tripId: 'trip-001',
            shift: 'Morning'),
        const Alert(id: 'a2', type: AlertType.trip, message: 'No trip here'),
      ];
      await tester.pumpWidget(app(const AlertsScreen(), path: '/alerts/a1'));
      await tester.pumpAndSettle();
      expect(find.text('Trip Details'), findsOneWidget);
      expect(find.text('Morning'), findsOneWidget);
      expect(find.text('View Trip'), findsOneWidget);
      await tester.tap(find.text('View Trip'));
      await tester.pumpAndSettle();
      expect(find.text('home-stub'), findsOneWidget);

      await tester.pumpWidget(app(const AlertsScreen(), path: '/alerts/a2'));
      await tester.pumpAndSettle();
      expect(find.text('Trip Details'), findsNothing);
    });
  });
}
