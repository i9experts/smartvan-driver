import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/passengers/data/models/scan_result.dart';
import 'package:smartvan_driver/features/scan/data/scan_repository.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late ScanRepository repo;
  final f = fixtureMap('passengers/scan_and_stop.json');
  const card = 'smartvan:kid:AbCdEfGhIjKlMnOpQrStUvWx';

  setUp(() {
    env = ApiTestEnv();
    repo = ScanRepository(env.client);
  });

  test('looksLikeCard accepts SmartVan cards only', () {
    expect(ScanRepository.looksLikeCard(card), isTrue);
    expect(ScanRepository.looksLikeCard('AbCdEfGhIjKlMnOpQrStUvWx'), isTrue);
    expect(ScanRepository.looksLikeCard('  $card  '), isTrue);
    expect(ScanRepository.looksLikeCard('https://example.test/promo'), isFalse);
    expect(ScanRepository.looksLikeCard('short'), isFalse);
  });

  test('scan POSTs tripId, trimmed payload and lat/lng (REST spelling)',
      () async {
    env.adapter.onPost(
        '/trips/scanStudent', (s) => s.reply(200, f['scanPicked']), data: {
      'tripId': 'trip-001',
      'qrPayload': card,
      'lat': 24.8607,
      'lng': 67.0011
    });
    final r = await repo.scan(
        tripId: 'trip-001',
        qrPayload: '  $card ',
        position: const GeoPoint(lat: 24.8607, lng: 67.0011));
    expect(r.action, ScanAction.picked);
    expect(r.fullname, 'Test Kid One');
  });

  test('without GPS only tripId and qrPayload are sent', () async {
    env.adapter.onPost(
        '/trips/scanStudent', (s) => s.reply(200, f['scanDropped']),
        data: {'tripId': 'trip-001', 'qrPayload': card});
    expect((await repo.scan(tripId: 'trip-001', qrPayload: card)).action,
        ScanAction.dropped);
  });

  for (final code in [
    ScanErrorCodes.invalidQr,
    ScanErrorCodes.kidNotOnTrip,
    ScanErrorCodes.alreadyPicked,
    ScanErrorCodes.alreadyDropped,
    ScanErrorCodes.locationRequired,
    ScanErrorCodes.tripNotOngoing,
  ]) {
    test('400 $code comes back as ApiError.code', () async {
      env.adapter.onPost('/trips/scanStudent',
          (s) => s.reply(400, {'message': 'nope', 'code': code}),
          data: Matchers.any);
      await expectLater(repo.scan(tripId: 't', qrPayload: card),
          throwsA(isA<ApiError>().having((e) => e.code, 'code', code)));
    });
  }

  test('offline is a NetworkException', () async {
    env.adapter.onPost('/trips/scanStudent',
        (s) => s.throws(0, connectionError('/trips/scanStudent')),
        data: Matchers.any);
    await expectLater(repo.scan(tripId: 't', qrPayload: card),
        throwsA(isA<NetworkException>()));
  });

  test('a body that is not a scan result is an UnknownException', () async {
    env.adapter.onPost(
        '/trips/scanStudent', (s) => s.reply(200, {'data': 'weird'}),
        data: Matchers.any);
    await expectLater(repo.scan(tripId: 't', qrPayload: card),
        throwsA(isA<UnknownException>()));
  });
}
