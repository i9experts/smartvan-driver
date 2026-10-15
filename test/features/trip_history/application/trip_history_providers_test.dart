import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_trail.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';
import 'package:smartvan_driver/features/trip_history/application/history_map_data.dart';
import 'package:smartvan_driver/features/trip_history/application/history_rows.dart';
import 'package:smartvan_driver/features/trip_history/application/trip_history_providers.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';

import '../../../support/trip_history_fakes.dart';

class _TripRepo extends Mock implements TripRepository {}

void main() {
  late MockHistoryRepo repo;
  late _TripRepo trips;
  // 10:00 PKT on 15 Oct 2026.
  final now = DateTime.utc(2026, 10, 15, 5, 0);

  ProviderContainer container() {
    final c = ProviderContainer(overrides: [
      tripHistoryRepositoryProvider.overrideWithValue(repo),
      tripRepositoryProvider.overrideWithValue(trips),
      clockProvider.overrideWithValue(() => now),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  setUpAll(() => registerFallbackValue(HistoryScope.all));

  setUp(() {
    repo = MockHistoryRepo();
    trips = _TripRepo();
  });

  group('todayCompletedTrips', () {
    test('asks for scope=today, three at most', () async {
      when(() => repo.completed(
          scope: any(named: 'scope'),
          limit: any(named: 'limit'))).thenAnswer((_) async => historyPage([]));
      await container().read(todayCompletedTripsProvider.future);
      verify(() => repo.completed(scope: HistoryScope.today, limit: 3))
          .called(1);
    });

    test('keeps only today\'s PKT trips and shows at most three', () async {
      when(() => repo.completed(
              scope: any(named: 'scope'), limit: any(named: 'limit')))
          .thenAnswer((_) async => historyPage([
                completedTrip('a', DateTime.utc(2026, 10, 15, 4)), // today
                // 23:30 UTC on the 14th = 04:30 PKT on the 15th: today
                completedTrip('b', DateTime.utc(2026, 10, 14, 23, 30)),
                // 18:59 UTC on the 14th = 23:59 PKT on the 14th: yesterday
                completedTrip('old', DateTime.utc(2026, 10, 14, 18, 59)),
                completedTrip('c', DateTime.utc(2026, 10, 15, 3)),
                completedTrip('d', DateTime.utc(2026, 10, 15, 2)),
              ]));
      final trips = await container().read(todayCompletedTripsProvider.future);
      expect(trips.map((t) => t.id), ['a', 'b', 'c']);
    });

    test('no trips today is an empty list', () async {
      when(() => repo.completed(
          scope: any(named: 'scope'),
          limit: any(named: 'limit'))).thenAnswer((_) async => historyPage([]));
      expect(
          await container().read(todayCompletedTripsProvider.future), isEmpty);
    });
  });

  group('TripHistory pagination', () {
    final p1 = [
      completedTrip('1', DateTime.utc(2026, 10, 15, 4)),
      completedTrip('2', DateTime.utc(2026, 10, 15, 3), type: TripType.drop),
    ];
    final p2 = [
      completedTrip('3', DateTime.utc(2026, 10, 14, 4)),
      completedTrip('2', DateTime.utc(2026, 10, 15, 3), type: TripType.drop),
    ];

    test('loads page 1, then appends page 2 without duplicates', () async {
      when(() => repo.completed(page: 1, limit: 20))
          .thenAnswer((_) async => historyPage(p1, hasMore: true));
      when(() => repo.completed(page: 2, limit: 20))
          .thenAnswer((_) async => historyPage(p2, page: 2, hasMore: false));
      final c = container();
      var state = await c.read(tripHistoryProvider.future);
      expect(state.items.map((t) => t.id), ['1', '2']);
      expect(state.hasMore, isTrue);

      await c.read(tripHistoryProvider.notifier).loadMore();
      state = c.read(tripHistoryProvider).requireValue;
      expect(state.items.map((t) => t.id), ['1', '2', '3']);
      expect((state.page, state.hasMore, state.loadingMore), (2, false, false));

      // The end was reached: no further request.
      await c.read(tripHistoryProvider.notifier).loadMore();
      verifyNever(() => repo.completed(page: 3, limit: 20));
    });

    test('a failed next page keeps the list and can be retried', () async {
      when(() => repo.completed(page: 1, limit: 20))
          .thenAnswer((_) async => historyPage(p1, hasMore: true));
      var calls = 0;
      when(() => repo.completed(page: 2, limit: 20)).thenAnswer((_) async {
        if (calls++ == 0) throw const NetworkException();
        return historyPage(p2, page: 2);
      });
      final c = container();
      await c.read(tripHistoryProvider.future);
      final notifier = c.read(tripHistoryProvider.notifier);

      await notifier.loadMore();
      var state = c.read(tripHistoryProvider).requireValue;
      expect(state.items, hasLength(2));
      expect(state.loadMoreFailed, isTrue);
      expect(state.loadingMore, isFalse);

      await notifier.loadMore();
      state = c.read(tripHistoryProvider).requireValue;
      expect(state.items.map((t) => t.id), ['1', '2', '3']);
      expect(state.loadMoreFailed, isFalse);
    });

    test('a first-page failure is an error state', () async {
      when(() => repo.completed(page: 1, limit: 20))
          .thenAnswer((_) async => throw const NetworkException());
      final c = container();
      await expectLater(
          c.read(tripHistoryProvider.future), throwsA(isA<NetworkException>()));
    });

    test('the filter shows one direction; empty pages are skipped over',
        () async {
      when(() => repo.completed(page: 1, limit: 20))
          .thenAnswer((_) async => historyPage(p1, hasMore: true));
      when(() => repo.completed(page: 2, limit: 20)).thenAnswer((_) async =>
          historyPage([completedTrip('x', DateTime.utc(2026, 10, 13))],
              page: 2, hasMore: true));
      when(() => repo.completed(page: 3, limit: 20)).thenAnswer((_) async =>
          historyPage([
            completedTrip('y', DateTime.utc(2026, 10, 12), type: TripType.drop)
          ], page: 3));
      final c = container();
      await c.read(tripHistoryProvider.future);
      final notifier = c.read(tripHistoryProvider.notifier);

      await notifier.setFilter(TripType.drop);
      expect(c.read(tripHistoryProvider).requireValue.visible.map((t) => t.id),
          ['2']); // already something to show: nothing more is fetched
      verifyNever(() => repo.completed(page: 2, limit: 20));

      await notifier.setFilter(null);
      expect(c.read(tripHistoryProvider).requireValue.visible, hasLength(2));
    });

    test('a filter with nothing visible keeps loading until it finds one',
        () async {
      when(() => repo.completed(page: 1, limit: 20)).thenAnswer((_) async =>
          historyPage([completedTrip('1', DateTime.utc(2026, 10, 15, 4))],
              hasMore: true));
      when(() => repo.completed(page: 2, limit: 20)).thenAnswer((_) async =>
          historyPage([completedTrip('2', DateTime.utc(2026, 10, 14))],
              page: 2, hasMore: true));
      when(() => repo.completed(page: 3, limit: 20)).thenAnswer((_) async =>
          historyPage([
            completedTrip('3', DateTime.utc(2026, 10, 13), type: TripType.drop)
          ], page: 3));
      final c = container();
      await c.read(tripHistoryProvider.future);
      await c.read(tripHistoryProvider.notifier).setFilter(TripType.drop);
      expect(c.read(tripHistoryProvider).requireValue.visible.map((t) => t.id),
          ['3']);
    });

    test('refresh reloads page 1 and keeps the filter', () async {
      var loads = 0;
      when(() => repo.completed(page: 1, limit: 20)).thenAnswer((_) async {
        loads++;
        return historyPage(p1);
      });
      final c = container();
      await c.read(tripHistoryProvider.future);
      await c.read(tripHistoryProvider.notifier).setFilter(TripType.pick);
      await c.read(tripHistoryProvider.notifier).refresh();
      expect(loads, 2);
      expect(c.read(tripHistoryProvider).requireValue.filter, TripType.pick);
    });
  });

  group('groupByDay', () {
    test('a header before each new PKT day', () {
      final rows = groupByDay([
        completedTrip('a', DateTime.utc(2026, 10, 15, 4)),
        completedTrip('b', DateTime.utc(2026, 10, 15, 2)),
        // 20:00 UTC on the 14th is already the 15th in PKT.
        completedTrip('c', DateTime.utc(2026, 10, 14, 20)),
        completedTrip('d', DateTime.utc(2026, 10, 14, 5)),
      ]);
      expect(
          rows.map((r) => switch (r) {
                HistoryHeaderRow(:final day) => 'H${day.day}',
                HistoryTripRow(:final trip) => trip.id,
              }),
          ['H15', 'a', 'b', 'c', 'H14', 'd']);
    });
  });

  group('trip details providers', () {
    test('historyTrail: a failed load is an empty trail, not an error',
        () async {
      when(() => trips.trail('t1'))
          .thenAnswer((_) async => throw const NetworkException());
      final trail = await container().read(historyTrailProvider('t1').future);
      expect(trail.path, isEmpty);
      expect(trailPoints(trail), isEmpty);
    });

    test('trailPoints prefers the path, then decodes the polyline', () {
      const withPath = TripTrail(path: [
        TrailPoint(lat: 24.9, lng: 67.1),
        TrailPoint(lat: 24.8, lng: 67.0),
      ]);
      expect(trailPoints(withPath), hasLength(2));
      // "_p~iF~ps|U_ulLnnqC_mqNvxq`@" is Google's documented example.
      const old = TripTrail(polyline: '_p~iF~ps|U_ulLnnqC_mqNvxq`@');
      expect(trailPoints(old), hasLength(3));
      expect(trailStart(old, trailPoints(old))?.latitude, 38.5);
      expect(trailEnd(old, trailPoints(old))?.latitude, 43.252);
    });

    test('boundsOf covers every point', () {
      final b = boundsOf(trailPoints(const TripTrail(path: [
        TrailPoint(lat: 24.9, lng: 67.1),
        TrailPoint(lat: 24.8, lng: 67.3),
      ])))!;
      expect((b.southwest.latitude, b.southwest.longitude), (24.8, 67.1));
      expect((b.northeast.latitude, b.northeast.longitude), (24.9, 67.3));
      expect(boundsOf(const []), isNull);
    });
  });
}
