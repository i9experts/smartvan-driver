import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/rating/application/rate_trip_controller.dart';
import 'package:smartvan_driver/features/rating/application/rating_providers.dart';
import 'package:smartvan_driver/features/rating/data/models/pending_ratee.dart';
import 'package:smartvan_driver/features/rating/data/models/rating_summary.dart';
import 'package:smartvan_driver/features/rating/data/rating_repository.dart';
import 'package:smartvan_driver/features/rating/presentation/screens/rate_trip_screen.dart';

import '../../support/l10n_host.dart';

class _FakeRatingRepo extends Mock implements RatingRepository {}

void main() {
  late _FakeRatingRepo repo;

  const one = PendingRatee(
      tripId: 'trip-001',
      parentId: 'p-1',
      parentName: 'Test Parent One',
      parentImage: null);
  const two = PendingRatee(tripId: 'trip-001', parentId: 'p-2');

  setUp(() {
    repo = _FakeRatingRepo();
    when(() => repo.pendingForTrip('trip-001'))
        .thenAnswer((_) async => [one, two]);
    when(() => repo.mySummary()).thenAnswer(
        (_) async => const RatingSummary(avgRating: 4.6, ratingCount: 12));
    when(() => repo.rateTrip(
          tripId: any(named: 'tripId'),
          rateeUserId: any(named: 'rateeUserId'),
          stars: any(named: 'stars'),
          comment: any(named: 'comment'),
        )).thenAnswer((_) async {});
  });

  List<Override> overrides() =>
      [ratingRepositoryProvider.overrideWithValue(repo)];

  group('providers', () {
    test('ratingSummary loads the summary', () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect((await c.read(ratingSummaryProvider.future)).ratingCount, 12);
    });

    test('ratingSummary: a failure is "no ratings yet", not an error',
        () async {
      when(() => repo.mySummary()).thenThrow(const NetworkException());
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect(await c.read(ratingSummaryProvider.future), const RatingSummary());
    });

    test('pendingRatees: a failure is an empty list', () async {
      when(() => repo.pendingForTrip(any()))
          .thenThrow(const NetworkException());
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect(await c.read(pendingRateesProvider('trip-001').future), isEmpty);
    });
  });

  group('RateTripController', () {
    Future<ProviderContainer> make() async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      c.listen(rateTripControllerProvider('trip-001'), (_, __) {});
      await c.read(rateTripControllerProvider('trip-001').future);
      return c;
    }

    RateTripController notifier(ProviderContainer c) =>
        c.read(rateTripControllerProvider('trip-001').notifier);

    test('starts on the first parent with no stars', () async {
      final c = await make();
      final s = c.read(rateTripControllerProvider('trip-001')).requireValue;
      expect(s.queue, [one, two]);
      expect(s.index, 0);
      expect(s.stars, 0);
    });

    test('submit does nothing until a star is picked', () async {
      final c = await make();
      expect(await notifier(c).submit('hi'), isNull);
      verifyNever(() => repo.rateTrip(
          tripId: any(named: 'tripId'),
          rateeUserId: any(named: 'rateeUserId'),
          stars: any(named: 'stars'),
          comment: any(named: 'comment')));
    });

    test('rating sends the stars and goes on to the next parent', () async {
      final c = await make();
      notifier(c).setStars(4);
      final r = await notifier(c).submit('Polite');
      expect(
          r,
          isA<RateTripAdvanced>()
              .having((a) => a.finished, 'finished', false)
              .having((a) => a.rated, 'rated', true));
      verify(() => repo.rateTrip(
          tripId: 'trip-001',
          rateeUserId: 'p-1',
          stars: 4,
          comment: 'Polite')).called(1);
      final s = c.read(rateTripControllerProvider('trip-001')).requireValue;
      expect(s.index, 1);
      expect(s.stars, 0);
      expect(s.submitting, isFalse);
    });

    test('rating the last parent finishes', () async {
      final c = await make();
      notifier(c).skip();
      notifier(c).setStars(5);
      final r = await notifier(c).submit('');
      expect((r as RateTripAdvanced).finished, isTrue);
    });

    test('skip moves on without a request; skipping the last finishes',
        () async {
      final c = await make();
      expect(notifier(c).skip().finished, isFalse);
      expect(notifier(c).skip().finished, isTrue);
      verifyNever(() => repo.rateTrip(
          tripId: any(named: 'tripId'),
          rateeUserId: any(named: 'rateeUserId'),
          stars: any(named: 'stars'),
          comment: any(named: 'comment')));
    });

    test('a failed rating stays on the same parent with the stars kept',
        () async {
      when(() => repo.rateTrip(
            tripId: any(named: 'tripId'),
            rateeUserId: any(named: 'rateeUserId'),
            stars: any(named: 'stars'),
            comment: any(named: 'comment'),
          )).thenThrow(const NetworkException());
      final c = await make();
      notifier(c).setStars(3);
      final r = await notifier(c).submit('');
      expect((r as RateTripFailed).error, isA<NetworkException>());
      final s = c.read(rateTripControllerProvider('trip-001')).requireValue;
      expect(s.index, 0);
      expect(s.stars, 3);
      expect(s.submitting, isFalse);
    });
  });

  group('RateTripScreen', () {
    Widget app() => routerHost(
          {
            '/rate/:tripId': (s) =>
                RateTripScreen(tripId: s.pathParameters['tripId']!),
            '/home': (_) => const Text('home-stub'),
          },
          initial: '/rate/trip-001',
          overrides: overrides(),
        );

    Future<void> pick(WidgetTester tester, int stars) async {
      await tester.tap(find.byIcon(Icons.star_border).at(stars - 1));
      await tester.pump();
    }

    testWidgets('asks about the first parent; submit needs a star',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Rate parent (1/2)'), findsOneWidget);
      expect(
          find.text('How was your trip with Test Parent One?'), findsOneWidget);
      expect(find.text('T'), findsOneWidget); // avatar initial
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
      final submit = find.widgetWithText(ElevatedButton, 'Submit Rating');
      expect(tester.widget<ElevatedButton>(submit).onPressed, isNull);
      await pick(tester, 4);
      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(tester.widget<ElevatedButton>(submit).onPressed, isNotNull);
    });

    testWidgets('rate, thank, next parent with a clean form, then home',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await pick(tester, 5);
      await tester.enterText(find.byType(TextField), '  Always ready ');
      await tester.tap(find.text('Submit Rating'));
      await tester.pumpAndSettle();
      verify(() => repo.rateTrip(
          tripId: 'trip-001',
          rateeUserId: 'p-1',
          stars: 5,
          comment: 'Always ready')).called(1);
      expect(find.text('Thanks for rating!'), findsOneWidget);
      expect(find.text('Rate parent (2/2)'), findsOneWidget);
      expect(find.text('How was your trip with this parent?'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty);

      await tester.pump(const Duration(seconds: 5)); // the snackbar leaves
      await tester.pumpAndSettle();
      await pick(tester, 2);
      await tester.tap(find.text('Submit Rating'));
      await tester.pumpAndSettle();
      expect(find.text('home-stub'), findsOneWidget);
    });

    testWidgets('Skip goes on without rating, and home after the last',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('Rate parent (2/2)'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('home-stub'), findsOneWidget);
      verifyNever(() => repo.rateTrip(
          tripId: any(named: 'tripId'),
          rateeUserId: any(named: 'rateeUserId'),
          stars: any(named: 'stars'),
          comment: any(named: 'comment')));
    });

    testWidgets('a failure shows the error and stays', (tester) async {
      when(() => repo.rateTrip(
            tripId: any(named: 'tripId'),
            rateeUserId: any(named: 'rateeUserId'),
            stars: any(named: 'stars'),
            comment: any(named: 'comment'),
          )).thenThrow(const NetworkException());
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await pick(tester, 3);
      await tester.tap(find.text('Submit Rating'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'Failed to submit rating: No internet connection. Please check your network and try again.'),
          findsOneWidget);
      expect(find.text('Rate parent (1/2)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(3));
    });

    testWidgets('nobody to rate goes straight home', (tester) async {
      when(() => repo.pendingForTrip('trip-001')).thenAnswer((_) async => []);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('home-stub'), findsOneWidget);
    });
  });
}
