import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/core/map/geo_math.dart';

void main() {
  const origin = LatLng(24.8607, 67.0011);

  test('distanceMeters: 0.001° of latitude is about 111 m', () {
    expect(distanceMeters(origin, const LatLng(24.8617, 67.0011)),
        closeTo(111.2, 0.5));
    expect(distanceMeters(origin, origin), 0);
  });

  test('bearingDegrees points along the compass', () {
    expect(
        bearingDegrees(origin, const LatLng(24.9, 67.0011)), closeTo(0, 0.01));
    expect(
        bearingDegrees(origin, const LatLng(24.8607, 67.1)), closeTo(90, 0.1));
    expect(bearingDegrees(origin, const LatLng(24.8, 67.0011)),
        closeTo(180, 0.01));
    expect(
        bearingDegrees(origin, const LatLng(24.8607, 66.9)), closeTo(270, 0.1));
  });

  test('normalizeDegrees folds into [0, 360)', () {
    expect(normalizeDegrees(370), 10);
    expect(normalizeDegrees(-10), 350);
    expect(normalizeDegrees(360), 0);
  });

  test('shortestTurn goes the short way round', () {
    expect(shortestTurn(350, 10), 20);
    expect(shortestTurn(10, 350), -20);
    expect(shortestTurn(0, 90), 90);
    expect(shortestTurn(0, 180), 180);
    expect(shortestTurn(90, 90), 0);
  });

  test('lerpDegrees crosses north instead of sweeping the long way', () {
    expect(lerpDegrees(350, 10, 0.5), 0);
    expect(lerpDegrees(350, 10, 0), 350);
    expect(lerpDegrees(350, 10, 1), 10);
    expect(lerpDegrees(10, 350, 0.5), 0);
  });

  test('lerpLatLng blends both coordinates', () {
    final mid = lerpLatLng(const LatLng(0, 0), const LatLng(2, 4), 0.5);
    expect(mid, const LatLng(1, 2));
  });
}
