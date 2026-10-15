import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip_history/data/models/completed_trips_page.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';
import 'package:smartvan_driver/features/trip_history/presentation/screens/trip_history_screen.dart';

import '../../../support/l10n_host.dart';
import '../../../support/trip_history_fakes.dart';

void main() {
  late MockHistoryRepo repo;
  // 10:00 PKT on 15 Oct 2026.
  final now = DateTime.utc(2026, 10, 15, 5, 0);

  setUpAll(() {
    registerFallbackValue(HistoryScope.all);
    initializeDateFormatting('en');
  });
  setUp(() => repo = MockHistoryRepo());

  Widget app() => routerHost(
        {
          '/trips/history': (_) => const TripHistoryScreen(),
          '/trips/history/:tripId': (s) =>
              Scaffold(body: Text('Details of ${s.pathParameters['tripId']}')),
        },
        initial: '/trips/history',
        overrides: [
          tripHistoryRepositoryProvider.overrideWithValue(repo),
          clockProvider.overrideWithValue(() => now),
        ],
      );

  void page(int n, CompletedTripsPage Function() build) =>
      when(() => repo.completed(page: n, limit: 20))
          .thenAnswer((_) async => build());

  testWidgets('shows a skeleton while the first page loads', (tester) async {
    useTallView(tester);
    final gate = Completer<CompletedTripsPage>();
    when(() => repo.completed(page: 1, limit: 20))
        .thenAnswer((_) => gate.future);
    await tester.pumpWidget(app());
    await tester.pump();
    expect(find.byKey(const Key('history-skeleton')), findsOneWidget);

    gate.complete(
        historyPage([completedTrip('a', DateTime.utc(2026, 10, 15, 3))]));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('history-skeleton')), findsNothing);
    expect(find.text('Route a'), findsOneWidget);
  });

  testWidgets('groups by Today / Yesterday / date', (tester) async {
    useTallView(tester);
    page(
        1,
        () => historyPage([
              completedTrip('a', DateTime.utc(2026, 10, 15, 3)),
              completedTrip('b', DateTime.utc(2026, 10, 14, 3)),
              completedTrip('c', DateTime.utc(2026, 10, 12, 3)),
            ]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Mon, 12 Oct 2026'), findsOneWidget);
  });

  testWidgets('an error shows Retry, which loads again', (tester) async {
    useTallView(tester);
    var calls = 0;
    when(() => repo.completed(page: 1, limit: 20)).thenAnswer((_) async {
      if (calls++ == 0) throw const NetworkException();
      return historyPage([completedTrip('a', DateTime.utc(2026, 10, 15, 3))]);
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.textContaining('No internet connection'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Route a'), findsOneWidget);
  });

  testWidgets('an empty history says so', (tester) async {
    useTallView(tester);
    page(1, () => historyPage([]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('No completed trips yet'), findsOneWidget);
  });

  testWidgets('scrolling to the end loads the next page', (tester) async {
    page(
        1,
        () => historyPage([
              for (var i = 0; i < 20; i++)
                completedTrip(
                    'p1-$i',
                    DateTime.utc(2026, 10, 15, 4)
                        .subtract(Duration(minutes: i))),
            ], hasMore: true));
    page(
        2,
        () => historyPage([
              completedTrip('older', DateTime.utc(2026, 10, 10, 3),
                  route: 'Older trip'),
            ], page: 2));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Older trip'), findsNothing);

    await tester.dragUntilVisible(
        find.text('Older trip'), find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Older trip'), findsOneWidget);
    verify(() => repo.completed(page: 2, limit: 20)).called(1);
  });

  testWidgets('a failed next page shows a retry row and keeps the list',
      (tester) async {
    useTallView(tester, height: 600);
    page(
        1,
        () => historyPage([
              for (var i = 0; i < 3; i++)
                completedTrip('p1-$i', DateTime.utc(2026, 10, 15, 4 - i)),
            ], hasMore: true));
    var calls = 0;
    when(() => repo.completed(page: 2, limit: 20)).thenAnswer((_) async {
      if (calls++ == 0) throw const NetworkException();
      return historyPage(
          [completedTrip('z', DateTime.utc(2026, 10, 9), route: 'Late one')],
          page: 2);
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Could not load more trips.'), findsOneWidget);
    expect(find.text('Route p1-0'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Late one'), findsOneWidget);
  });

  testWidgets('pull to refresh reloads the first page', (tester) async {
    useTallView(tester, height: 600);
    var loads = 0;
    when(() => repo.completed(page: 1, limit: 20)).thenAnswer((_) async {
      loads++;
      return historyPage([
        completedTrip('a', DateTime.utc(2026, 10, 15, 3), route: 'Load $loads')
      ]);
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Load 1'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(find.text('Load 2'), findsOneWidget);
  });

  testWidgets('the Pick / Drop chips filter the list', (tester) async {
    useTallView(tester);
    page(
        1,
        () => historyPage([
              completedTrip('a', DateTime.utc(2026, 10, 15, 4),
                  route: 'Morning run'),
              completedTrip('b', DateTime.utc(2026, 10, 15, 2),
                  type: TripType.drop, route: 'Afternoon run'),
            ]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Morning run'), findsOneWidget);
    expect(find.text('Afternoon run'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Drop off'));
    await tester.pumpAndSettle();
    expect(find.text('Morning run'), findsNothing);
    expect(find.text('Afternoon run'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.text('Morning run'), findsOneWidget);
  });

  testWidgets('tapping a trip opens its details', (tester) async {
    useTallView(tester);
    page(
        1,
        () => historyPage(
            [completedTrip('trip-7', DateTime.utc(2026, 10, 15, 3))]));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Route trip-7'));
    await tester.pumpAndSettle();
    expect(find.text('Details of trip-7'), findsOneWidget);
  });
}
