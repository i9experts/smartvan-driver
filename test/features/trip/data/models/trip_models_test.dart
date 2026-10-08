import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/assigned_route.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/kid_not_dropped.dart';
import 'package:smartvan_driver/features/trip/data/models/trip.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';

import '../../../../support/fixture.dart';

void main() {
  group('Trip', () {
    test('parses a trip document', () {
      final t = Trip.fromJson(fixtureMap('trip/trip_ongoing.json'));
      expect(t.id, '65f000000000000000000a01');
      expect(t.status, TripStatus.ongoing);
      expect(t.type, TripType.pick);
      expect(t.name, 'Sample School - Morning Pick');
      expect(t.routeId, '65f000000000000000000b01');
      expect(t.createdAt, DateTime.utc(2026, 10, 6, 7, 55));
      expect(t.startTime, DateTime.utc(2026, 10, 6, 8, 0));
    });

    test('absorbs id, status, type and name variants', () {
      final list = asJsonList(unwrapData(fixture('trip/trips_list.json')))
          .map(Trip.fromJson)
          .toList();
      expect(list[0].id, 't-1'); // `id`
      expect(list[0].status, TripStatus.ongoing); // "Active"
      expect(list[0].type, TripType.drop); // "Drop" is case-insensitive
      expect(list[0].name, 'Sample School - Afternoon Drop');
      expect(list[0].startTime,
          DateTime.utc(2026, 10, 6, 12, 5)); // flat startTime
      expect(list[1].id, 't-2'); // `_id`
      expect(list[1].status, TripStatus.completed); // "end"
      expect(list[1].name, 'Sample School - Morning Pick'); // schoolRoute
      expect(list[2].status, TripStatus.ongoing); // "start"
      expect(list[3].status, TripStatus.completed);
    });

    test('unknown / missing values fall back to unknown', () {
      final list = asJsonList(unwrapData(fixture('trip/trips_list.json')))
          .map(Trip.fromJson)
          .toList();
      expect(list[4].status, TripStatus.unknown); // "scheduled"
      expect(list[4].type, TripType.unknown); // "shuttle"
      expect(list[5].status, TripStatus.unknown);
      expect(list[5].type, TripType.unknown);
      expect(list[5].id, 't-6');
      expect(list[5].name, isNull);
    });
  });

  group('AssignedRoute', () {
    final routes = asJsonList(unwrapData(fixture('trip/assigned_routes.json')))
        .map(AssignedRoute.fromJson)
        .toList();

    test('a started pick route with passengers', () {
      final r = routes[0];
      expect(r.routeId, '65f000000000000000000b01');
      expect(r.routeTitle, 'Sample School - Morning Pick');
      expect(r.vehicleNumber, 'TST-1234');
      expect(r.startTime, DateTime.utc(2026, 10, 6, 8));
      expect(r.tripType, TripType.pick);
      expect(r.tripStarted, isTrue); // PascalCase TripStarted
      expect(r.tripDetails?.id, '65f000000000000000000a01');
      expect(r.tripDetails?.status, TripStatus.ongoing);
      expect(r.passengers, hasLength(2));
      expect(r.passengers[0].kidId, 'kid-001');
      expect(r.passengers[0].fullname, 'Test Kid One');
      expect(r.passengers[0].image, 'https://example.test/img/1.png');
      expect(r.passengers[1].image, isNull);
      expect(r.passengers[1].grade, '4'); // number as grade
    });

    test('a not-started drop route', () {
      final r = routes[1];
      expect(r.tripType, TripType.drop);
      expect(r.tripStarted, isFalse);
      expect(r.tripDetails, isNull);
      expect(r.passengers, isEmpty);
    });

    test('sparse route: lower-case tripStarted string, unknown type', () {
      final r = routes[2];
      expect(r.routeId, '65f000000000000000000b03');
      expect(r.tripType, TripType.unknown);
      expect(r.tripStarted, isTrue);
      expect(r.routeTitle, isNull);
      expect(r.passengers, isEmpty);
    });
  });

  group('ActiveTrip start time', () {
    test('comes from the trip document and survives save and restore', () {
      final trip = Trip.fromJson(fixtureMap('trip/trip_ongoing.json'));
      final active = ActiveTrip.fromTrip(trip, routeTitle: 'R');
      expect(active.startTime, DateTime.utc(2026, 10, 6, 8));
      final restored = ActiveTrip.fromJson(active.toJson());
      expect(restored.startTime, active.startTime);
      expect(restored.type, TripType.pick);
    });

    test('is null when the trip has none', () {
      expect(ActiveTrip.fromJson(const {'id': 't'}).startTime, isNull);
    });
  });

  test('KidNotDropped reads the kids of a KIDS_NOT_DROPPED body', () {
    final body = fixtureMap('trip/kids_not_dropped_error.json');
    final kids = asJsonList(body['kids']).map(KidNotDropped.fromJson).toList();
    expect(kids, hasLength(2));
    expect(kids[0].kidId, 'kid-001');
    expect(kids[0].fullname, 'Test Kid One');
    expect(kids[1].kidId, 'kid-002'); // `_id`
    expect(kids[1].fullname, 'Test Kid Two'); // `name`
  });

  group('GeoPoint', () {
    final payloads = fixtureMap('trip/location_payloads.json');

    test('reads lng and long', () {
      final a =
          GeoPoint.fromJson(Map<String, dynamic>.from(payloads['rest'] as Map));
      final b = GeoPoint.fromJson(
          Map<String, dynamic>.from(payloads['socketAndEndTrip'] as Map));
      expect(a, b);
      expect(a.lat, 24.8607);
      expect(a.lng, 67.0011);
    });

    test('numbers as strings', () {
      final p = GeoPoint.fromJson(
          Map<String, dynamic>.from(payloads['asStrings'] as Map));
      expect(p.lat, 24.8607);
      expect(p.lng, 67.0011);
    });

    test('always writes lng', () {
      expect(const GeoPoint(lat: 1, lng: 2).toJson(), {'lat': 1.0, 'lng': 2.0});
    });
  });
}
