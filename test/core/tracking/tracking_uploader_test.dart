import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/api_client.dart';
import 'package:smartvan_driver/core/network/interceptors.dart';
import 'package:smartvan_driver/core/tracking/location_buffer.dart';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';
import 'package:smartvan_driver/core/tracking/tracking_uploader.dart';

/// A server whose connection and answers the test controls.
class FakeServer implements HttpClientAdapter {
  bool up = true;

  /// Every try, also the ones that never connected.
  int attempts = 0;

  /// Answers by path; default 201.
  final Map<String, ({int status, Object body})> answers = {};
  final List<({String path, Map<String, dynamic> body})> requests = [];

  Iterable<Map<String, dynamic>> posts(String path) =>
      requests.where((r) => r.path == path).map((r) => r.body);

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    attempts++;
    if (!up) {
      throw DioException.connectionError(
          requestOptions: options, reason: 'offline');
    }
    requests.add((
      path: options.path,
      body: Map<String, dynamic>.from(options.data as Map),
    ));
    final answer = answers[options.path] ?? (status: 201, body: {'ok': true});
    return ResponseBody.fromString(jsonEncode(answer.body), answer.status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        });
  }

  @override
  void close({bool force = false}) {}
}

TrackedPoint pt(int i, {double? speed = 5}) => TrackedPoint(
    lat: 24 + i / 10000,
    lng: 67,
    time: DateTime.utc(2026, 10, 13, 12).add(Duration(seconds: i)),
    speed: speed);

void main() {
  late FakeServer server;
  late MemoryLocationBuffer buffer;
  late DateTime now;
  late TrackingUploader uploader;
  var tripOver = 0;

  const live = '/trips/updateLocation/t1';
  const batch = '/trips/t1/locations/batch';

  setUp(() {
    server = FakeServer();
    buffer = MemoryLocationBuffer();
    now = DateTime.utc(2026, 10, 13, 12);
    tripOver = 0;
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = server;
    dio.interceptors.add(ErrorInterceptor(onUnauthorized: () async {}));
    uploader = TrackingUploader(
      tripId: 't1',
      api: ApiClient(dio),
      buffer: buffer,
      clock: () => now,
      onTripOver: () => tripOver++,
    );
  });

  void tick(int seconds) => now = now.add(Duration(seconds: seconds));

  group('online', () {
    test('the first point goes at once, with speed', () async {
      await uploader.submit(pt(0, speed: 8));
      expect(server.posts(live), [
        {'lat': 24.0, 'lng': 67.0, 'speed': 8.0}
      ]);
    });

    test('one live POST per 5 s: the points in between are not sent', () async {
      await uploader.submit(pt(0));
      tick(2);
      await uploader.submit(pt(2));
      tick(2);
      await uploader.submit(pt(4));
      expect(server.posts(live), hasLength(1));
      tick(1); // 5 s since the first
      await uploader.submit(pt(5));
      expect(server.posts(live), hasLength(2));
      expect(server.posts(live).last['lat'], 24.0005);
      expect(await buffer.count('t1'), 0, reason: 'online: nothing is stored');
    });

    test('force posts at once (the stand-still heartbeat)', () async {
      await uploader.submit(pt(0));
      tick(1);
      await uploader.submit(pt(1, speed: 0), force: true);
      expect(server.posts(live), hasLength(2));
    });

    test('unknown speed is left out', () async {
      await uploader.submit(pt(0, speed: null));
      expect(server.posts(live).single.containsKey('speed'), isFalse);
    });

    test('TRIP_NOT_ONGOING tells the caller and stores nothing', () async {
      server.answers[live] =
          (status: 400, body: {'code': 'TRIP_NOT_ONGOING', 'message': 'over'});
      await uploader.submit(pt(0));
      expect(tripOver, 1);
      expect(await buffer.count('t1'), 0);
      expect(uploader.offline, isFalse);
    });

    test('a point the server refuses for good is dropped, not retried',
        () async {
      server.answers[live] = (status: 400, body: {'message': 'bad lat'});
      await uploader.submit(pt(0));
      expect(await buffer.count('t1'), 0);
      expect(uploader.offline, isFalse);
    });
  });

  group('offline', () {
    test('a failed POST goes offline and keeps the point', () async {
      server.up = false;
      await uploader.submit(pt(0));
      expect(uploader.offline, isTrue);
      expect((await buffer.next('t1', 10)).map((b) => b.point), [pt(0)]);
    });

    test('a server error counts as offline too', () async {
      server.answers[live] = (status: 503, body: {'message': 'down'});
      await uploader.submit(pt(0));
      expect(uploader.offline, isTrue);
      expect(await buffer.count('t1'), 1);
    });

    test('an expired login keeps the points for later', () async {
      server.answers[live] = (status: 401, body: {'message': 'expired'});
      await uploader.submit(pt(0));
      expect(await buffer.count('t1'), 1);
    });

    test('every point is stored, even within the 5 s', () async {
      server.up = false;
      await uploader.submit(pt(0));
      for (var i = 1; i <= 4; i++) {
        tick(1);
        await uploader.submit(pt(i));
      }
      expect(await buffer.count('t1'), 5);
      expect(server.requests, isEmpty);
    });

    test('it probes the connection once per 5 s', () async {
      server.up = false;
      await uploader.submit(pt(0));
      expect(server.attempts, 1);
      for (var s = 1; s <= 10; s++) {
        tick(1);
        await uploader.submit(pt(s));
      }
      expect(server.attempts, 3, reason: 'at 5 s and 10 s only');
      expect(await buffer.count('t1'), 11);
    });

    test('back online: the probe is sent live, the rest as one batch in order',
        () async {
      server.up = false;
      await uploader.submit(pt(0));
      tick(1);
      await uploader.submit(pt(1));
      tick(1);
      await uploader.submit(pt(2));
      server.up = true;
      tick(5);
      await uploader.submit(pt(7));

      expect(uploader.offline, isFalse);
      expect(server.posts(live), hasLength(1));
      expect(server.posts(live).single['lat'], 24.0007);
      final sent = server.posts(batch).single['points'] as List;
      expect(sent.map((p) => (p as Map)['lat']), [24.0, 24.0001, 24.0002]);
      expect((sent.first as Map)['time'], '2026-10-13T12:00:00.000Z');
      expect((sent.first as Map)['speed'], 5.0);
      expect(await buffer.count('t1'), 0,
          reason: 'accepted batches are deleted');
    });

    test('batches carry at most 2000 points', () async {
      for (var i = 0; i < 2500; i++) {
        await buffer.add('t1', pt(i));
      }
      await uploader.flush();
      final calls = server.posts(batch).toList();
      expect(calls.map((c) => (c['points'] as List).length), [2000, 500]);
      expect(await buffer.count('t1'), 0);
    });

    test('a failed batch keeps everything for the next try', () async {
      for (var i = 0; i < 3; i++) {
        await buffer.add('t1', pt(i));
      }
      server.up = false;
      await uploader.flush();
      expect(await buffer.count('t1'), 3);
      expect(uploader.offline, isTrue);
      server.up = true;
      await uploader.flush();
      expect(await buffer.count('t1'), 0);
      expect(uploader.offline, isFalse);
    });

    test('a batch the server refuses (trip too old) is dropped', () async {
      await buffer.add('t1', pt(0));
      server.answers[batch] =
          (status: 400, body: {'code': 'TRIP_TOO_OLD', 'message': 'late'});
      await uploader.flush();
      expect(await buffer.count('t1'), 0);
    });

    test('leftovers of an earlier run go with the next successful POST',
        () async {
      await buffer.add('t1', pt(0));
      await uploader.submit(pt(10));
      expect(server.posts(batch), hasLength(1));
      expect(await buffer.count('t1'), 0);
    });

    test('points of another trip stay where they are', () async {
      await buffer.add('other', pt(0));
      await uploader.flush();
      expect(server.requests, isEmpty);
      expect(await buffer.count('other'), 1);
    });
  });
}
