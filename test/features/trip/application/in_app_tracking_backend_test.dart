import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart' as loc;
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/tracking/location_buffer.dart';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';
import 'package:smartvan_driver/core/tracking/tracking_session.dart';
import 'package:smartvan_driver/features/trip/application/in_app_tracking_backend.dart';

import '../../../support/fake_location.dart';
import '../../../support/fake_server.dart';

void main() {
  late FakeLocation location;
  late FakeServer server;
  late MemoryLocationBuffer buffer;
  late InAppTrackingBackend backend;
  late DateTime now;
  late List<TrackedPoint> fixes;
  var tripOver = 0;

  const session = TrackingSession(sessionId: 's1', deviceId: 'd1', claimed: true);
  const live = '/trips/updateLocation/t1';
  const batch = '/trips/t1/locations/batch';

  setUp(() {
    location = FakeLocation();
    server = FakeServer();
    buffer = MemoryLocationBuffer();
    now = DateTime.utc(2026, 10, 13, 12);
    fixes = [];
    tripOver = 0;
    backend = InAppTrackingBackend(
      location: location,
      api: fakeServerClient(server),
      openBuffer: () async => buffer,
      clock: () => now,
    );
    backend.fixes.listen(fixes.add);
    backend.tripOver.listen((_) => tripOver++);
    addTearDown(() async {
      await backend.dispose();
      await location.close();
    });
  });

  Future<void> fix(double lat, double lng, {double? speed}) async {
    location.emit(lat, lng, speed: speed);
    await pumpEventQueue();
  }

  test('starting: GPS every 2 s / 3 m, background mode on, listening',
      () async {
    await backend.start('t1', session);
    verify(() => location.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        interval: 2000,
        distanceFilter: 3)).called(1);
    verify(() => location.enableBackgroundMode(enable: true)).called(1);
    expect(location.hasListener, isTrue);
  });

  test('a fix is reported and uploaded live (one HTTP place)', () async {
    await backend.start('t1', session);
    await fix(24.86, 67.0, speed: 8);
    expect(fixes.single.lat, 24.86);
    expect(server.posts(live).single, {
      'lat': 24.86,
      'lng': 67.0,
      'speed': 8.0,
      'sessionId': 's1',
      'deviceId': 'd1',
    });
  });

  test('the fix a still van is found at when tracking starts is sent too',
      () async {
    when(() => location.getLocation()).thenAnswer((_) async =>
        loc.LocationData.fromMap({'latitude': 9.0, 'longitude': 8.0}));
    await backend.start('t1', session);
    await pumpEventQueue();
    expect(server.posts(live).single['lat'], 9.0);
    expect(fixes.single.lat, 9.0);
  });

  test('without a connection every point is kept, then batch-uploaded',
      () async {
    await backend.start('t1', session);
    server.up = false;
    await fix(24.1, 67.0, speed: 5);
    now = now.add(const Duration(seconds: 1));
    await fix(24.2, 67.0, speed: 6);
    now = now.add(const Duration(seconds: 1));
    await fix(24.3, 67.0, speed: 7);
    expect(await buffer.count('t1'), 3);

    server.up = true;
    now = now.add(const Duration(seconds: 6));
    await fix(24.4, 67.0, speed: 8);
    final points = server.posts(batch).single['points'] as List;
    expect(points.map((p) => (p as Map)['lat']), [24.1, 24.2, 24.3]);
    expect(await buffer.count('t1'), 0);
    expect(server.posts(live).last['lat'], 24.4);
  });

  test('the server saying the trip is over is reported', () async {
    server.answers[live] =
        (status: 400, body: {'code': 'TRIP_NOT_ONGOING', 'message': 'over'});
    await backend.start('t1', session);
    await fix(1, 2);
    expect(tripOver, 1);
  });

  test('stopping ends the GPS stream and background mode', () async {
    await backend.start('t1', session);
    await backend.stop();
    expect(location.hasListener, isFalse);
    verify(() => location.enableBackgroundMode(enable: false)).called(1);
    await fix(1, 2);
    expect(fixes, isEmpty);
  });

  test('starting again replaces the running trip', () async {
    await backend.start('t1', session);
    await backend.start('t2', session);
    await fix(1, 2);
    expect(server.posts('/trips/updateLocation/t2'), hasLength(1));
    expect(server.posts(live), isEmpty);
  });
}
