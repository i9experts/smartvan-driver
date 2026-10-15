import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';
import 'package:smartvan_driver/features/trip_history/presentation/widgets/today_completed_section.dart';

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

  void serve(List items) => when(() => repo.completed(
          scope: any(named: 'scope'), limit: any(named: 'limit')))
      .thenAnswer((_) async => historyPage(List.from(items)));

  Widget app() => routerHost(
        {
          '/home': (_) => const Scaffold(
              body: SingleChildScrollView(child: TodayCompletedSection())),
          '/trips/history': (_) => const Scaffold(body: Text('History page')),
          '/trips/history/:tripId': (s) =>
              Scaffold(body: Text('Details of ${s.pathParameters['tripId']}')),
        },
        initial: '/home',
        overrides: [
          tripHistoryRepositoryProvider.overrideWithValue(repo),
          clockProvider.overrideWithValue(() => now),
        ],
      );

  testWidgets('shows today\'s trip as a card with every field', (tester) async {
    useTallView(tester);
    serve([
      completedTrip('a', DateTime.utc(2026, 10, 15, 3, 41),
          route: 'Gulshan Morning'),
    ]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text("Today's completed trips"), findsOneWidget);
    expect(find.text('Gulshan Morning'), findsOneWidget);
    expect(find.text('Pick up'), findsOneWidget);
    // Ended 08:41 PKT, started 41 minutes earlier.
    expect(find.text('8:00 AM – 8:41 AM'), findsOneWidget);
    expect(find.text('41 min'), findsOneWidget);
    expect(find.text('12 students'), findsOneWidget);
  });

  testWidgets('a drop trip is labelled Drop off', (tester) async {
    useTallView(tester);
    serve([
      completedTrip('a', DateTime.utc(2026, 10, 15, 3), type: TripType.drop)
    ]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Drop off'), findsOneWidget);
  });

  testWidgets('never more than three cards', (tester) async {
    useTallView(tester);
    serve([
      for (var i = 0; i < 5; i++)
        completedTrip('t$i', DateTime.utc(2026, 10, 15, 4 - i),
            route: 'Trip $i'),
    ]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Trip 0'), findsOneWidget);
    expect(find.text('Trip 2'), findsOneWidget);
    expect(find.text('Trip 3'), findsNothing);
  });

  testWidgets('no trips today shows the empty note', (tester) async {
    useTallView(tester);
    serve([]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('No trips completed today'), findsOneWidget);
    expect(find.text('View all'), findsOneWidget);
  });

  testWidgets('a failed load says so and Retry loads again', (tester) async {
    useTallView(tester);
    var calls = 0;
    when(() => repo.completed(
        scope: any(named: 'scope'),
        limit: any(named: 'limit'))).thenAnswer((_) async {
      if (calls++ == 0) throw const NetworkException();
      return historyPage([
        completedTrip('a', DateTime.utc(2026, 10, 15, 3), route: 'Back again')
      ]);
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Could not load your trips.'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Back again'), findsOneWidget);
  });

  testWidgets('tapping a card opens its details', (tester) async {
    useTallView(tester);
    serve(
        [completedTrip('trip-9', DateTime.utc(2026, 10, 15, 3), route: 'R9')]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('R9'));
    await tester.pumpAndSettle();
    expect(find.text('Details of trip-9'), findsOneWidget);
  });

  testWidgets('View all opens the history', (tester) async {
    useTallView(tester);
    serve([]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.text('History page'), findsOneWidget);
  });
}
