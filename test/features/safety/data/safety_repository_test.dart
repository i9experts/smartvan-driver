import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/safety/data/safety_repository.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

import '../../../support/api_env.dart';

void main() {
  late ApiTestEnv env;
  late SafetyRepository repo;
  const here = GeoPoint(lat: 24.8607, lng: 67.0011);

  setUp(() {
    env = ApiTestEnv();
    repo = SafetyRepository(env.client);
  });

  test('sendSos POSTs lat/lng (REST spelling) and returns parentsNotified',
      () async {
    env.adapter.onPost(
      '/alert/sos',
      (s) => s.reply(201, {
        'success': true,
        'data': {'parentsNotified': 7},
      }),
      data: {
        'tripId': 'trip-001',
        'lat': 24.8607,
        'lng': 67.0011,
        'message': 'Flat tyre'
      },
    );
    expect(
        await repo.sendSos(
            tripId: 'trip-001', position: here, message: '  Flat tyre '),
        7);
  });

  test('without a trip or message only lat/lng are sent; missing count is 0',
      () async {
    env.adapter.onPost('/alert/sos', (s) => s.reply(201, {'data': {}}),
        data: {'lat': 24.8607, 'lng': 67.0011});
    expect(await repo.sendSos(position: here, message: '   '), 0);
  });

  test('429 SOS_RATE_LIMITED is an ApiError with that code', () async {
    env.adapter.onPost(
      '/alert/sos',
      (s) => s.reply(429, {
        'message': 'SOS already sent a moment ago',
        'code': 'SOS_RATE_LIMITED'
      }),
      data: Matchers.any,
    );
    await expectLater(
        repo.sendSos(position: here),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', 'SOS_RATE_LIMITED')
            .having((e) => e.status, 'status', 429)));
  });

  test('offline: NetworkException', () async {
    env.adapter.onPost(
        '/alert/sos', (s) => s.throws(0, connectionError('/alert/sos')),
        data: Matchers.any);
    await expectLater(
        repo.sendSos(position: here), throwsA(isA<NetworkException>()));
  });
}
