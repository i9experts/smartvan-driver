import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/trip/data/kids_not_dropped_error.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late TripRepository repo;
  const here = GeoPoint(lat: 24.8607, lng: 67.0011);

  setUp(() {
    env = ApiTestEnv();
    repo = TripRepository(env.client);
  });

  group('assignedRoutes', () {
    test('GETs /Route/getAssignedTripByDriver (capital R)', () async {
      env.adapter.onGet('/Route/getAssignedTripByDriver',
          (s) => s.reply(200, fixture('trip/assigned_routes.json')));
      final routes = await repo.assignedRoutes();
      expect(routes, hasLength(4));
      expect(routes.first.tripStarted, isTrue);
      expect(routes.first.passengers, hasLength(2));
    });

    test('a driver without a van gets a 400 ApiError', () async {
      env.adapter.onGet(
          '/Route/getAssignedTripByDriver',
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

  group('optimizeRoute', () {
    test('POSTs the trip and the position (long, not lng)', () async {
      env.adapter.onPost(
        '/trips/optimizeRoute',
        (s) => s.reply(201, fixture('trip/optimize_route.json')),
        data: {'tripId': 'trip-001', 'lat': 24.8607, 'long': 67.0011},
      );
      final r = await repo.optimizeRoute(tripId: 'trip-001', position: here);
      expect(r.stops.map((s) => s.kidName),
          ['Test Kid Two', 'Test Kid One', null]);
      expect(r.durationSavedMinutes, 8);
    });

    test('an error from the server is thrown', () async {
      env.adapter.onPost(
          '/trips/optimizeRoute',
          (s) => s.reply(400, {
                'message': 'This route has no stops to optimize',
                'statusCode': 400,
              }),
          data: Matchers.any);
      await expectLater(
          repo.optimizeRoute(tripId: 't', position: here),
          throwsA(isA<ApiError>().having((e) => e.userMessage, 'message',
              'This route has no stops to optimize')));
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

  group('socketLocationPayload', () {
    test('nests lat/lng under location, with speed and heading', () {
      expect(
          TripRepository.socketLocationPayload('trip-001', here,
              speedMetersPerSecond: 8.5, heading: 270),
          {
            'tripId': 'trip-001',
            'location': {'lat': 24.8607, 'lng': 67.0011},
            'speed': 8.5,
            'heading': 270,
          });
    });

    test('leaves out unknown or negative speed / heading', () {
      expect(
          TripRepository.socketLocationPayload('trip-001', here,
              speedMetersPerSecond: -1, heading: -1),
          {
            'tripId': 'trip-001',
            'location': {'lat': 24.8607, 'lng': 67.0011},
          });
      expect(TripRepository.socketLocationPayload('trip-001', here),
          isNot(contains('speed')));
    });
  });
}
