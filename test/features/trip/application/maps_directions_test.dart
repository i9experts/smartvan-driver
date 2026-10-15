import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/trip/application/maps_directions.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/optimized_route.dart';

void main() {
  const origin = GeoPoint(lat: 24.8607, lng: 67.0011);
  const destination = GeoPoint(lat: 24.95, lng: 67.2);

  test('origin, destination and the stops in order as waypoints', () {
    final uri = googleMapsDirectionsUri(const OptimizedRoute(
      origin: origin,
      destination: destination,
      stops: [
        OptimizedStop(lat: 24.9, lng: 67.1),
        OptimizedStop(lat: 24.91, lng: 67.12),
      ],
    ))!;
    expect(uri.scheme, 'https');
    expect(uri.host, 'www.google.com');
    expect(uri.path, '/maps/dir/');
    expect(uri.queryParameters, {
      'api': '1',
      'origin': '24.8607,67.0011',
      'destination': '24.95,67.2',
      'waypoints': '24.9,67.1|24.91,67.12',
      'travelmode': 'driving',
    });
  });

  test('stops without coordinates are left out; none means no waypoints', () {
    final some = googleMapsDirectionsUri(const OptimizedRoute(
      origin: origin,
      destination: destination,
      stops: [OptimizedStop(), OptimizedStop(lat: 24.9, lng: 67.1)],
    ))!;
    expect(some.queryParameters['waypoints'], '24.9,67.1');
    final none = googleMapsDirectionsUri(
        const OptimizedRoute(origin: origin, destination: destination))!;
    expect(none.queryParameters.containsKey('waypoints'), isFalse);
  });

  test('no origin or destination means nothing to open', () {
    expect(
        googleMapsDirectionsUri(const OptimizedRoute(destination: destination)),
        isNull);
    expect(
        googleMapsDirectionsUri(const OptimizedRoute(origin: origin)), isNull);
  });

  OptimizedStop stop(int i) =>
      OptimizedStop(sequence: i, lat: 20.0 + i, lng: 67.1);

  test('a drop trip ends at its last stop: no separate destination point', () {
    final stops = [stop(1), stop(2), stop(3)];
    final route = OptimizedRoute(
      origin: origin,
      destination: const GeoPoint(lat: 23, lng: 67.1),
      stops: stops,
    );
    final uri = googleMapsDirectionsUri(route)!;
    expect(uri.queryParameters['destination'], '23.0,67.1');
    expect(uri.queryParameters['waypoints'], '21.0,67.1|22.0,67.1');
    expect(googleMapsLinkIsPartial(route), isFalse);
  });

  test('more stops than Google Maps takes: the link covers the next ten', () {
    final route = OptimizedRoute(
      origin: origin,
      destination: destination,
      stops: [for (var i = 1; i <= 12; i++) stop(i)],
    );
    final uri = googleMapsDirectionsUri(route)!;
    expect(uri.queryParameters['waypoints']!.split('|'), hasLength(9));
    expect(uri.queryParameters['destination'], '30.0,67.1');
    expect(googleMapsLinkIsPartial(route), isTrue);
  });

  test('exactly ten points still fit', () {
    final route = OptimizedRoute(
      origin: origin,
      destination: destination,
      stops: [for (var i = 1; i <= 9; i++) stop(i)],
    );
    expect(googleMapsLinkIsPartial(route), isFalse);
    final uri = googleMapsDirectionsUri(route)!;
    expect(uri.queryParameters['destination'], '24.95,67.2');
  });
}
