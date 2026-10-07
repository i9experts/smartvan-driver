import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';
import 'package:smartvan_driver/features/trip/data/kids_not_dropped_error.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fake_sync_queue.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late FakeSyncQueue queue;
  late TripRepository repo;
  const here = GeoPoint(lat: 24.8607, lng: 67.0011);

  setUp(() {
    env = ApiTestEnv();
    queue = FakeSyncQueue();
    repo = TripRepository(env.client, queue);
  });

  group('assignedRoutes', () {
    test('GETs /route/getAssignedTripByDriver (lower-case route)', () async {
      env.adapter.onGet('/route/getAssignedTripByDriver',
          (s) => s.reply(200, fixture('trip/assigned_routes.json')));
      final routes = await repo.assignedRoutes();
      expect(routes, hasLength(3));
      expect(routes.first.tripStarted, isTrue);
      expect(routes.first.passengers, hasLength(2));
    });

    test('a driver without a van gets a 400 ApiError', () async {
      env.adapter.onGet(
          '/route/getAssignedTripByDriver',
          (s) => s.reply(400, {
                'message': 'Van not found for this driver',
                'error': 'Bad Request',
                'statusCode': 400,
              }));
      await expectLater(
          repo.assignedRoutes(),
          throwsA(isA<ApiError>().having((e) => e.status, 'status', 400).having(
              (e) => e.userMessage,
              'message',
              'Van not found for this driver')));
    });
  });

  test('driverTrips GETs /trips/getDriverTrips', () async {
    env.adapter.onGet('/trips/getDriverTrips',
        (s) => s.reply(200, fixture('trip/trips_list.json')));
    final trips = await repo.driverTrips();
    expect(trips, hasLength(6));
    expect(trips.first.status, TripStatus.ongoing);
  });

  group('startTrip', () {
    test('POSTs routeId and type pick', () async {
      env.adapter.onPost('/trips/startTrip',
          (s) => s.reply(201, {'data': fixture('trip/trip_ongoing.json')}),
          data: {'routeId': 'route-001', 'type': 'pick'});
      final t = await repo.startTrip(routeId: 'route-001', type: TripType.pick);
      expect(t.id, '65f000000000000000000a01');
      expect(t.status, TripStatus.ongoing);
    });

    test('type drop', () async {
      env.adapter.onPost(
          '/trips/startTrip',
          (s) => s.reply(201, {
                'data': {'_id': 't2'}
              }),
          data: {'routeId': 'route-002', 'type': 'drop'});
      expect(
          (await repo.startTrip(routeId: 'route-002', type: TripType.drop)).id,
          't2');
    });

    test('an unknown type is sent as pick (the old default)', () async {
      env.adapter.onPost(
          '/trips/startTrip',
          (s) => s.reply(201, {
                'data': {'_id': 't3'}
              }),
          data: {'routeId': 'route-003', 'type': 'pick'});
      await repo.startTrip(routeId: 'route-003', type: TripType.unknown);
    });

    test('CHECKLIST_REQUIRED is an ApiError code', () async {
      env.adapter.onPost(
          '/trips/startTrip',
          (s) => s.reply(400, {
                'message': 'Complete the van check first',
                'code': 'CHECKLIST_REQUIRED'
              }),
          data: Matchers.any);
      await expectLater(
          repo.startTrip(routeId: 'r', type: TripType.pick),
          throwsA(isA<ApiError>().having(
              (e) => e.code, 'code', TripErrorCodes.checklistRequired)));
    });
  });

  group('endTrip', () {
    test('sends tripId, lat and `long` (not `lng`)', () async {
      env.record();
      env.adapter.onPost(
          '/trips/endTrip', (s) => s.reply(200, {'success': true}),
          data: {'tripId': 'trip-001', 'lat': 24.8607, 'long': 67.0011});
      await repo.endTrip(tripId: 'trip-001', position: here);
      final body = env.lastRequest!.data as Map;
      expect(body.containsKey('long'), isTrue);
      expect(body.containsKey('lng'), isFalse);
      expect(body.containsKey('forceEnd'), isFalse);
    });

    test('without a position only tripId is sent', () async {
      env.adapter.onPost('/trips/endTrip', (s) => s.reply(200, {}),
          data: {'tripId': 'trip-001'});
      await repo.endTrip(tripId: 'trip-001');
    });

    test('forceEnd adds forceEnd and the confirmation note', () async {
      env.adapter.onPost('/trips/endTrip', (s) => s.reply(200, {}), data: {
        'tripId': 'trip-001',
        'lat': 24.8607,
        'long': 67.0011,
        'forceEnd': true,
        'confirmationNote': 'Checked the van, it is empty',
      });
      await repo.endTrip(
          tripId: 'trip-001',
          position: here,
          forceEnd: true,
          confirmationNote: 'Checked the van, it is empty');
    });

    test('forceEnd without a note sends an empty confirmationNote', () async {
      env.adapter.onPost('/trips/endTrip', (s) => s.reply(200, {}), data: {
        'tripId': 'trip-001',
        'forceEnd': true,
        'confirmationNote': ''
      });
      await repo.endTrip(tripId: 'trip-001', forceEnd: true);
    });

    test(
        '409 KIDS_NOT_DROPPED: code on ApiError, kids typed from ApiError.data',
        () async {
      env.adapter.onPost('/trips/endTrip',
          (s) => s.reply(409, fixture('trip/kids_not_dropped_error.json')),
          data: Matchers.any);
      try {
        await repo.endTrip(tripId: 'trip-001');
        fail('should throw');
      } on ApiError catch (e) {
        expect(e.code, TripErrorCodes.kidsNotDropped);
        expect(e.status, 409);
        expect(e.isKidsNotDropped, isTrue);
        final kids = e.kidsNotDropped;
        expect(kids.map((k) => k.kidId), ['kid-001', 'kid-002']);
        expect(kids.map((k) => k.fullname), ['Test Kid One', 'Test Kid Two']);
      }
    });

    test('kidsNotDropped is empty for other errors and bodies without kids',
        () {
      expect(
          const ApiError(code: 'OTHER', status: 400, data: {'kids': []})
              .kidsNotDropped,
          isEmpty);
      expect(
          const ApiError(code: 'KIDS_NOT_DROPPED', status: 409).kidsNotDropped,
          isEmpty);
      expect(
          const ApiError(
              code: 'KIDS_NOT_DROPPED',
              status: 409,
              data: {'kids': 'x'}).kidsNotDropped,
          isEmpty);
    });

    test('TRIP_NOT_ONGOING is an ApiError code', () async {
      env.adapter.onPost(
          '/trips/endTrip',
          (s) => s.reply(400,
              {'message': 'Trip is not ongoing', 'code': 'TRIP_NOT_ONGOING'}),
          data: Matchers.any);
      await expectLater(
          repo.endTrip(tripId: 't'),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', TripErrorCodes.tripNotOngoing)));
    });
  });

  group('sendLocation (offline queue)', () {
    test('goes through the queue as kind location with `lng` and speed',
        () async {
      queue.outcome = SubmitOutcome.sent;
      final outcome = await repo.sendLocation(
          tripId: 'trip-001', position: here, speedMetersPerSecond: 9.5);
      expect(outcome, SubmitOutcome.sent);
      final call = queue.calls.single;
      expect(call.kind, SyncKind.location);
      expect(call.path, '/trips/updateLocation/trip-001');
      expect(call.body, {'lat': 24.8607, 'lng': 67.0011, 'speed': 9.5});
      expect(call.body.containsKey('long'), isFalse);
      expect(call.tripId, 'trip-001');
      expect(call.kidId, isNull);
    });

    test('speed is left out when unknown or negative', () async {
      await repo.sendLocation(tripId: 't', position: here);
      await repo.sendLocation(
          tripId: 't', position: here, speedMetersPerSecond: -1);
      expect(queue.calls[0].body, {'lat': 24.8607, 'lng': 67.0011});
      expect(queue.calls[1].body, {'lat': 24.8607, 'lng': 67.0011});
    });

    test('zero speed is sent (the van is standing still)', () async {
      await repo.sendLocation(
          tripId: 't', position: here, speedMetersPerSecond: 0);
      expect(queue.calls.single.body['speed'], 0.0);
    });

    test('queued outcome is passed on', () async {
      queue.outcome = SubmitOutcome.queued;
      expect(await repo.sendLocation(tripId: 't', position: here),
          SubmitOutcome.queued);
    });

    test('TRIP_NOT_ONGOING from the server is an ApiError code', () async {
      queue.error = dioStatus(
          400, {'message': 'Trip is not ongoing', 'code': 'TRIP_NOT_ONGOING'});
      await expectLater(
          repo.sendLocation(tripId: 't', position: here),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', TripErrorCodes.tripNotOngoing)));
    });
  });

  test('socketLocationPayload nests lat/long under location', () {
    expect(TripRepository.socketLocationPayload('trip-001', here), {
      'tripId': 'trip-001',
      'location': {'lat': 24.8607, 'long': 67.0011},
    });
  });
}
