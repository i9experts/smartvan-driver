import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/tracking/location_buffer.dart';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';
import 'package:smartvan_driver/core/tracking/tracking_session.dart';
import 'package:smartvan_driver/core/tracking/tracking_uploader.dart';

import '../../support/fake_server.dart';

TrackedPoint pt(int i, {double? accuracy}) => TrackedPoint(
    lat: 24 + i / 10000,
    lng: 67,
    time: DateTime.utc(2026, 10, 13, 12).add(Duration(seconds: i)),
    speed: 5,
    accuracy: accuracy);

void main() {
  late FakeServer server;
  late MemoryLocationBuffer buffer;
  late DateTime now;
  late TrackingUploader uploader;
  var replaced = 0;
  var claimedCalls = 0;
  var tripOver = 0;

  const live = '/trips/updateLocation/t1';
  const batch = '/trips/t1/locations/batch';
  const claim = '/trips/t1/tracking-session';
  const fresh = TrackingSession(sessionId: 's1', deviceId: 'd1');
  const ids = {'sessionId': 's1', 'deviceId': 'd1'};

  TrackingUploader make(TrackingSession? session) => TrackingUploader(
        tripId: 't1',
        api: fakeServerClient(server),
        buffer: buffer,
        clock: () => now,
        session: session,
        onSessionReplaced: () => replaced++,
        onSessionClaimed: () => claimedCalls++,
        onTripOver: () => tripOver++,
      );

  setUp(() {
    server = FakeServer();
    buffer = MemoryLocationBuffer();
    now = DateTime.utc(2026, 10, 13, 12);
    replaced = claimedCalls = tripOver = 0;
  });

  void tick(int s) => now = now.add(Duration(seconds: s));

  test('ids are random and the same phone keeps its device id', () {
    final a = TrackingSession.create('dev');
    final b = TrackingSession.create('dev');
    expect(a.sessionId, isNot(b.sessionId));
    expect(a.sessionId, hasLength(32));
    expect(a.deviceId, b.deviceId);
    expect(a.claimed, isFalse);
    expect(a.asClaimed.claimed, isTrue);
  });

  group('no session (nothing changes for the old way)', () {
    test('the body has no ids and nothing is claimed', () async {
      uploader = make(null);
      await uploader.submit(pt(0));
      expect(server.posts(claim), isEmpty);
      expect(server.posts(live).single.containsKey('sessionId'), isFalse);
    });
  });

  group('claiming', () {
    test('the trip is claimed once, before the first point, then ids ride along', () async {
      uploader = make(fresh);
      await uploader.submit(pt(0));
      tick(5);
      await uploader.submit(pt(5));
      expect(server.posts(claim), [ids]);
      expect(claimedCalls, 1);
      expect(server.posts(live), hasLength(2));
      expect(server.posts(live).every((b) => b['sessionId'] == 's1' && b['deviceId'] == 'd1'), isTrue);
    });

    test('an already claimed session (a restarted service) does not claim again', () async {
      uploader = make(fresh.asClaimed);
      await uploader.submit(pt(0));
      expect(server.posts(claim), isEmpty);
      expect(server.posts(live).single['sessionId'], 's1');
    });

    test('no connection: the point is kept, the claim is retried with the next probe', () async {
      uploader = make(fresh);
      server.up = false;
      await uploader.submit(pt(0));
      expect(uploader.offline, isTrue);
      expect(await buffer.count('t1'), 1);
      expect(claimedCalls, 0);
      server.up = true;
      tick(5);
      await uploader.submit(pt(5));
      expect(server.posts(claim), [ids]);
      expect(uploader.offline, isFalse);
      // the buffered point went with a batch carrying the ids, after the claim
      expect(server.posts(batch).single['sessionId'], 's1');
    });

    test('a session the server refuses for good: carry on without ids', () async {
      server.answers[claim] = (status: 400, body: {'code': 'SESSION_ID_REQUIRED', 'message': 'x'});
      uploader = make(fresh);
      await uploader.submit(pt(0));
      expect(server.posts(live).single.containsKey('sessionId'), isFalse);
      expect(replaced, 0);
    });

    test('claiming a trip that is over tells the caller', () async {
      server.answers[claim] = (status: 400, body: {'code': 'TRIP_NOT_ONGOING', 'message': 'over'});
      uploader = make(fresh);
      await uploader.submit(pt(0));
      expect(tripOver, 1);
      expect(server.posts(live), isEmpty);
    });
  });

  group('replaced by another phone', () {
    const gone = (status: 409, body: {'success': false, 'code': 'TRACKING_SESSION_REPLACED', 'message': 'other device'});

    test('409 on a live point: the caller is told once, nothing is stored, nothing more is sent', () async {
      uploader = make(fresh.asClaimed);
      server.answers[live] = gone;
      await uploader.submit(pt(0));
      expect(replaced, 1);
      expect(await buffer.count('t1'), 0);
      expect(uploader.offline, isFalse);
      tick(5);
      await uploader.submit(pt(5));
      tick(5);
      await uploader.submit(pt(10), force: true);
      expect(server.posts(live), hasLength(1));
      expect(replaced, 1);
    });

    test('409 on a batch: the held points are dropped and the caller is told', () async {
      uploader = make(fresh.asClaimed);
      server.up = false;
      await uploader.submit(pt(0));
      await uploader.submit(pt(1));
      expect(await buffer.count('t1'), 2);
      server.up = true;
      server.answers[batch] = gone;
      await uploader.flush();
      expect(replaced, 1);
      expect(await buffer.count('t1'), 0);
    });
  });

  group('what a point carries', () {
    test('accuracy goes with live points and batches; live points have no time', () async {
      uploader = make(fresh.asClaimed);
      await uploader.submit(pt(0, accuracy: 12));
      final body = server.posts(live).single;
      expect(body['accuracy'], 12.0);
      expect(body.containsKey('time'), isFalse);

      server.up = false;
      tick(5);
      await uploader.submit(pt(5, accuracy: 8));
      server.up = true;
      await uploader.flush();
      final sent = server.posts(batch).single;
      expect(sent['sessionId'], 's1');
      expect((sent['points'] as List).single['accuracy'], 8.0);
      expect((sent['points'] as List).single['time'], isNotNull);
    });
  });
}
