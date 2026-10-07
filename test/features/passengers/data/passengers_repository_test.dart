import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';
import 'package:smartvan_driver/features/passengers/data/models/absence.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_trip_status.dart';
import 'package:smartvan_driver/features/passengers/data/passengers_repository.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

import '../../../support/api_env.dart';
import '../../../support/fake_sync_queue.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late FakeSyncQueue queue;
  late PassengersRepository repo;
  final f = fixtureMap('passengers/scan_and_stop.json');

  setUp(() {
    env = ApiTestEnv();
    queue = FakeSyncQueue();
    repo = PassengersRepository(env.client, queue);
  });

  test('activePassengers GETs /Route/getMergedActivePassengers (capital R)',
      () async {
    env.adapter.onGet(
        '/Route/getMergedActivePassengers',
        (s) =>
            s.reply(200, fixture('passengers/merged_active_passengers.json')));
    final list = await repo.activePassengers();
    expect(list, hasLength(4));
    expect(list[1].absent, isTrue);
    expect(list[1].noShow, isTrue);
    expect(list[0].parent.phoneNo, '0300-0000001');
  });

  test('activePassengers: no active trip is an ApiError', () async {
    env.adapter.onGet(
        '/Route/getMergedActivePassengers',
        (s) => s.reply(
            400, {'message': 'No active trip', 'code': 'TRIP_NOT_ONGOING'}));
    await expectLater(
        repo.activePassengers(),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', StopErrorCodes.tripNotOngoing)));
  });

  group('pick (offline queue)', () {
    test('goes through the queue as kind pick with tripId and kidId', () async {
      queue.outcome = SubmitOutcome.sent;
      expect(await repo.pick(tripId: 'trip-001', kidId: 'kid-001'),
          SubmitOutcome.sent);
      final call = queue.calls.single;
      expect(call.kind, SyncKind.pick);
      expect(call.path, '/trips/pickStudent');
      expect(call.body, {'tripId': 'trip-001', 'kidId': 'kid-001'});
      expect(call.tripId, 'trip-001');
      expect(call.kidId, 'kid-001');
    });

    test('queued means saved offline', () async {
      queue.outcome = SubmitOutcome.queued;
      expect(await repo.pick(tripId: 't', kidId: 'k'), SubmitOutcome.queued);
    });

    test('a server rejection comes back as ApiError (ALREADY_PICKED)',
        () async {
      queue.error = dioStatus(
          400, {'message': 'Already picked', 'code': 'ALREADY_PICKED'});
      await expectLater(
          repo.pick(tripId: 't', kidId: 'k'),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', StopErrorCodes.alreadyPicked)));
    });
  });

  group('drop (offline queue)', () {
    test('sends lat and `long` (not `lng`) as kind drop', () async {
      await repo.drop(
          tripId: 'trip-001',
          kidId: 'kid-001',
          position: const GeoPoint(lat: 24.8607, lng: 67.0011));
      final call = queue.calls.single;
      expect(call.kind, SyncKind.drop);
      expect(call.path, '/trips/dropStudentForHome');
      expect(call.body, {
        'tripId': 'trip-001',
        'kidId': 'kid-001',
        'lat': 24.8607,
        'long': 67.0011,
      });
      expect(call.body.containsKey('lng'), isFalse);
      expect(call.tripId, 'trip-001');
      expect(call.kidId, 'kid-001');
    });

    test('a 5xx or network failure is the queue\'s business, a 4xx is ours',
        () async {
      queue.error = dioStatus(400,
          {'message': 'Kid is not on this trip', 'code': 'KID_NOT_ON_TRIP'});
      await expectLater(
          repo.drop(
              tripId: 't',
              kidId: 'k',
              position: const GeoPoint(lat: 1, lng: 2)),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', StopErrorCodes.kidNotOnTrip)));
    });
  });

  test('pendingStatuses converts the queue\'s strings to KidTripStatus', () {
    queue.pendingStatusMap = {'kid-001': 'picked', 'kid-002': 'dropped'};
    expect(repo.pendingStatuses('trip-001'), {
      'kid-001': KidTripStatus.picked,
      'kid-002': KidTripStatus.dropped,
    });
    expect(queue.pendingQueriedFor, 'trip-001');
  });

  group('arrivedAtStop', () {
    test('POSTs tripId and kidId and parses waitingSince', () async {
      env.adapter.onPost(
          '/trips/arrivedAtStop', (s) => s.reply(201, f['arrived']),
          data: {'tripId': 'trip-001', 'kidId': 'kid-002'});
      final r = await repo.arrivedAtStop(tripId: 'trip-001', kidId: 'kid-002');
      expect(r.kidId, 'kid-002');
      expect(r.waitingSince, DateTime.utc(2026, 10, 6, 8, 12));
    });

    test('NOT_PICK_TRIP and TRIP_NOT_YOURS come back as codes', () async {
      for (final code in [
        StopErrorCodes.notPickTrip,
        StopErrorCodes.tripNotYours
      ]) {
        env.adapter.onPost('/trips/arrivedAtStop',
            (s) => s.reply(400, {'message': 'x', 'code': code}),
            data: Matchers.any);
        await expectLater(repo.arrivedAtStop(tripId: 't', kidId: 'k'),
            throwsA(isA<ApiError>().having((e) => e.code, 'code', code)));
      }
    });
  });

  group('markNoShow', () {
    test('sends a trimmed note when there is one', () async {
      env.adapter.onPost(
          '/trips/noShow', (s) => s.reply(201, {'success': true}), data: {
        'tripId': 'trip-001',
        'kidId': 'kid-002',
        'note': 'Nobody at the gate'
      });
      await repo.markNoShow(
          tripId: 'trip-001', kidId: 'kid-002', note: '  Nobody at the gate ');
    });

    test('omits a blank or missing note', () async {
      env.adapter.onPost('/trips/noShow', (s) => s.reply(201, {}),
          data: {'tripId': 'trip-001', 'kidId': 'kid-002'});
      await repo.markNoShow(tripId: 'trip-001', kidId: 'kid-002', note: '   ');
      await repo.markNoShow(tripId: 'trip-001', kidId: 'kid-002');
    });

    test('NOT_PICK_TRIP is an ApiError code', () async {
      env.adapter.onPost(
          '/trips/noShow',
          (s) => s.reply(
              400, {'message': 'Not a pick trip', 'code': 'NOT_PICK_TRIP'}),
          data: Matchers.any);
      await expectLater(
          repo.markNoShow(tripId: 't', kidId: 'k'),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', StopErrorCodes.notPickTrip)));
    });
  });

  test('todayAbsences GETs /kid/absence/today', () async {
    env.adapter.onGet('/kid/absence/today',
        (s) => s.reply(200, fixture('passengers/absences_today.json')));
    final list = await repo.todayAbsences();
    expect(list, hasLength(3));
    expect(list.first.tripType, AbsenceTripType.both);
    expect(list.first.kidId, 'kid-002');
  });
}
