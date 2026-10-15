import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_trail.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip_history/data/models/trip_details.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late TripHistoryRepository repo;

  setUp(() {
    env = ApiTestEnv()..record();
    repo = TripHistoryRepository(env.client);
  });

  group('completed', () {
    test('GETs /driver/trips/completed with scope, page and limit', () async {
      env.adapter.onGet('/driver/trips/completed',
          (s) => s.reply(200, fixture('trip_history/completed_page.json')),
          queryParameters: {'scope': 'today', 'page': 2, 'limit': 3});
      final page =
          await repo.completed(scope: HistoryScope.today, page: 2, limit: 3);
      expect(env.lastRequest!.queryParameters,
          {'scope': 'today', 'page': 2, 'limit': 3});
      expect(page.items, hasLength(2));
    });

    test('defaults to scope=all, page 1, 20 per page', () async {
      env.adapter.onGet('/driver/trips/completed',
          (s) => s.reply(200, fixture('trip_history/completed_page.json')),
          queryParameters: {'scope': 'all', 'page': 1, 'limit': 20});
      await repo.completed();
    });

    test('parses the page and absorbs the backend variants', () async {
      env.adapter.onGet('/driver/trips/completed',
          (s) => s.reply(200, fixture('trip_history/completed_page.json')),
          queryParameters: {'scope': 'all', 'page': 1, 'limit': 20});
      final page = await repo.completed();
      expect(
          (page.total, page.page, page.limit, page.hasMore), (37, 1, 20, true));

      final a = page.items[0];
      expect(a.id, 'trip-1');
      expect(a.routeName, 'Gulshan Morning');
      expect(a.tripType, TripType.pick);
      expect(a.startedAt, DateTime.utc(2026, 10, 15, 2, 0, 4));
      expect(a.endedAt, DateTime.utc(2026, 10, 15, 2, 41, 10));
      expect((a.durationSeconds, a.distanceMeters), (2466, 11840));
      expect((a.studentCount, a.pickedCount, a.droppedCount), (12, 10, 0));
      expect((a.absentCount, a.noShowCount), (1, 1));

      final b = page.items[1]; // `_id`, "DROP", string number, null number
      expect(b.id, 'trip-2');
      expect(b.routeName, isNull);
      expect(b.tripType, TripType.drop);
      expect(b.durationSeconds, 1800);
      expect(b.distanceMeters, 0);
    });

    test('a page without items is empty, not an error', () async {
      env.adapter.onGet(
          '/driver/trips/completed',
          (s) => s.reply(200, {
                'success': true,
                'data': {'items': []}
              }),
          queryParameters: {'scope': 'all', 'page': 1, 'limit': 20});
      final page = await repo.completed();
      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
    });
  });

  group('details', () {
    test('GETs /driver/trips/:id/details and parses it', () async {
      env.adapter.onGet('/driver/trips/trip-1/details',
          (s) => s.reply(200, fixture('trip_history/details.json')));
      final d = await repo.details('trip-1');
      expect(d.trip.routeName, 'Gulshan Morning');
      expect(d.stops.map((s) => s.order), [1, 2]);
      expect(d.stops.first.placeName, 'House 12, Block 5');
      expect(d.students.map((s) => (s.name, s.status)), [
        ('Ayesha Test', StudentOutcome.picked),
        ('Bilal Test', StudentOutcome.absent),
        ('Sana Test', StudentOutcome.noShow),
      ]);
      expect(d.students.first.at, DateTime.utc(2026, 10, 15, 2, 10));
      expect(d.students[1].at, isNull);
      expect(d.alerts.map((a) => a.type),
          [TripAlertKind.overspeed, TripAlertKind.sos]);
      expect(d.school?.name, 'City School');
      expect((d.school?.lat, d.school?.lng), (24.86, 67.0));
    });

    test('a school without a saved location is null; unknown values fall back',
        () {
      final d = TripDetails.fromJson({
        'id': 't',
        'school': null,
        'stops': [
          {
            'order': 1,
            'students': [
              {'kidId': 'k', 'name': 'N', 'status': 'teleported'}
            ]
          }
        ],
        'alerts': [
          {'type': 'meteor'}
        ],
      });
      expect(d.school, isNull);
      expect(d.stops.single.lat, isNull);
      expect(d.students.single.status, StudentOutcome.unknown);
      expect(d.alerts.single.type, TripAlertKind.unknown);
    });

    test('404 TRIP_NOT_FOUND and 403 TRIP_NOT_YOURS are ApiErrors', () async {
      env.adapter.onGet(
          '/driver/trips/nope/details',
          (s) => s.reply(
              404, {'code': 'TRIP_NOT_FOUND', 'message': 'Trip not found'}));
      env.adapter.onGet(
          '/driver/trips/other/details',
          (s) => s.reply(
              403, {'code': 'TRIP_NOT_YOURS', 'message': 'Not your trip'}));
      await expectLater(
          repo.details('nope'),
          throwsA(isA<ApiError>()
              .having((e) => e.status, 'status', 404)
              .having((e) => e.code, 'code', 'TRIP_NOT_FOUND')));
      await expectLater(
          repo.details('other'),
          throwsA(
              isA<ApiError>().having((e) => e.code, 'code', 'TRIP_NOT_YOURS')));
    });
  });

  group('TripTrail', () {
    test('reads path, start, end and endedAt next to the polyline', () {
      final trail = TripTrail.fromJson(Map<String, dynamic>.from(
          fixtureMap('trip_history/trail.json')['data'] as Map));
      expect(trail.path, hasLength(3));
      expect(trail.start?.lat, 24.9);
      expect(trail.end?.lng, 67.0);
      expect(trail.endedAt, DateTime.utc(2026, 10, 15, 2, 41, 10));
      expect(trail.pathPoints.last.lat, 24.86);
    });

    test('an old trail with only a polyline still parses', () {
      final trail = TripTrail.fromJson({'polyline': 'abc', 'points': 3});
      expect(trail.polyline, 'abc');
      expect(trail.path, isEmpty);
    });
  });
}
