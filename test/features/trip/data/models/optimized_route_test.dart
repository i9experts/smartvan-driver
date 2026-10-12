import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/trip/data/models/optimized_route.dart';

import '../../../../support/fixture.dart';

void main() {
  OptimizedRoute parse(Map<String, dynamic> json) =>
      OptimizedRoute.fromJson(json);

  test('parses the optimizeRoute response', () {
    final r = parse(asJsonMap(unwrapData(fixture('trip/optimize_route.json'))));
    expect(r.stops, hasLength(3));
    expect(r.stops[0].kidName, 'Test Kid Two');
    expect(r.stops[0].sequence, 1);
    expect(r.stops[0].lat, 24.9);
    expect(r.stops[0].lng, 67.1); // the backend spells it `long`
    expect(r.stops[2].kidName, isNull);
    expect(r.stops[2].lat, isNull);
    expect(r.origin!.lat, 24.8607);
    expect(r.origin!.lng, 67.0011);
    expect(r.destination!.lng, 67.2);
    expect(r.distanceSavedMeters, 2600);
    expect(r.distanceSavedKm, 2.6);
    expect(r.durationSavedMinutes, 8);
    expect(r.hasSavings, isTrue);
  });

  test('a missing or incomplete origin / destination is null', () {
    final r = parse({
      'stops': <Object>[],
      'origin': {'lat': 24.8},
    });
    expect(r.origin, isNull);
    expect(r.destination, isNull);
  });

  test('numbers as strings; no savings when under 50 m and half a minute', () {
    final r = parse({
      'distanceSavedMeters': '40',
      'durationSavedSeconds': 29,
    });
    expect(r.distanceSavedMeters, 40);
    expect(r.hasSavings, isFalse);
    expect(parse({'durationSavedSeconds': 31}).hasSavings, isTrue);
    expect(parse({'distanceSavedMeters': 60}).hasSavings, isTrue);
    expect(parse({'distanceSavedMeters': -500}).hasSavings, isFalse);
  });

  test('an empty object gives no stops and no savings', () {
    final r = parse({});
    expect(r.stops, isEmpty);
    expect(r.hasSavings, isFalse);
  });
}
