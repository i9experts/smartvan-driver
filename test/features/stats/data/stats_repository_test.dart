import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/stats/data/stats_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late StatsRepository repo;

  setUp(() {
    env = ApiTestEnv();
    repo = StatsRepository(env.client);
  });

  for (final days in [7, 30]) {
    test('driverStats(days: $days) GETs /trips/driver-stats?days=$days',
        () async {
      env.adapter.onGet('/trips/driver-stats',
          (s) => s.reply(200, fixture('stats/driver_stats.json')),
          queryParameters: {'days': days});
      final stats = await repo.driverStats(days: days);
      expect(stats.trips, 14);
      expect(stats.safetyScore, 92.0);
    });
  }

  test('server error maps to ServerException', () async {
    env.adapter.onGet('/trips/driver-stats', (s) => s.reply(500, {}),
        queryParameters: {'days': 7});
    await expectLater(
        repo.driverStats(days: 7), throwsA(isA<ServerException>()));
  });
}
