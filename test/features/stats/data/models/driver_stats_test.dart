import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/stats/data/models/driver_stats.dart';

import '../../../../support/fixture.dart';

void main() {
  test('parses driver stats', () {
    final s = DriverStats.fromJson(
        asJsonMap(unwrapData(fixture('stats/driver_stats.json'))));
    expect(s.safetyScore, 92.0);
    expect(s.onTimePercent, 88.5);
    expect(s.overspeedCount, 3);
    expect(s.speedLimitKmh, 60);
    expect(s.trips, 14);
    expect(s.distanceKm, 210.4);
    expect(s.drivingMinutes, 540);
    expect(s.kidsDropped, 96);
    expect(s.maxSpeedKmh, 71.3);
  });

  test('numbers as strings, optional fields missing', () {
    final s = DriverStats.fromJson(
        asJsonMap(unwrapData(fixture('stats/driver_stats_variants.json'))));
    expect(s.safetyScore, 100.0); // "100"
    expect(s.overspeedCount, 0);
    expect(s.speedLimitKmh, 60); // "60"
    expect(s.onTimePercent, isNull);
    expect(s.maxSpeedKmh, isNull);
    expect(s.trips, 0);
  });

  test('empty object gives zeros and nulls, not exceptions', () {
    final s = DriverStats.fromJson({});
    expect(s.trips, 0);
    expect(s.distanceKm, 0.0);
    expect(s.safetyScore, isNull);
  });
}
