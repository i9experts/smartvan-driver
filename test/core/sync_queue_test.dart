import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' show InterceptorsWrapper;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';

import '../support/api_env.dart';

/// Lets queued work finish: the queue writes to a real Hive box (file I/O),
/// which the fake event loop cannot flush, so wait on the real clock.
Future<void> settle() =>
    Future<void>.delayed(const Duration(milliseconds: 100));

void main() {
  late Directory dir;
  late ApiTestEnv env;
  late DateTime now;
  late StreamController<bool> online;
  var boxCounter = 0;

  setUpAll(() {
    dir = Directory.systemTemp.createTempSync('smartvan_queue_test');
    Hive.init(dir.path);
  });

  tearDownAll(() async {
    await Hive.close();
    dir.deleteSync(recursive: true);
  });

  setUp(() {
    env = ApiTestEnv();
    now = DateTime(2026, 10, 6, 8, 0);
    online = StreamController<bool>.broadcast();
    addTearDown(online.close);
  });

  Future<SyncQueue> makeQueue() async {
    final q = SyncQueue(
      env.client,
      onlineChanges: () => online.stream,
      clock: () => now,
      retryEvery: const Duration(hours: 1),
      boxName: 'q${boxCounter++}',
    );
    await q.init();
    addTearDown(q.dispose);
    return q;
  }

  Map<String, dynamic> pickBody(String kid) => {'tripId': 't1', 'kidId': kid};

  Future<SubmitOutcome> pick(SyncQueue q, String kid) => q.submit(
        kind: SyncKind.pick,
        path: '/trips/pickStudent',
        body: pickBody(kid),
        tripId: 't1',
        kidId: kid,
      );

  Future<SubmitOutcome> location(SyncQueue q, double lat) => q.submit(
        kind: SyncKind.location,
        path: '/trips/updateLocation/t1',
        body: {'lat': lat, 'lng': 67.0},
        tripId: 't1',
      );

  test('online: sent straight away, nothing queued', () async {
    env.adapter.onPost('/trips/pickStudent', (s) => s.reply(200, {}),
        data: pickBody('k1'));
    final q = await makeQueue();
    expect(await pick(q, 'k1'), SubmitOutcome.sent);
    expect(q.pending.value, 0);
  });

  test('offline: queued; the pending status is visible', () async {
    env.adapter.onPost('/trips/pickStudent',
        (s) => s.throws(0, connectionError('/trips/pickStudent')),
        data: Matchers.any);
    final q = await makeQueue();
    expect(await pick(q, 'k1'), SubmitOutcome.queued);
    expect(q.pending.value, 1);
    expect(q.pendingKidStatuses('t1'), {'k1': 'picked'});
    expect(q.pendingKidStatuses('other-trip'), isEmpty);
  });

  test('a 5xx is queued too', () async {
    env.adapter.onPost('/trips/pickStudent', (s) => s.reply(503, {}),
        data: Matchers.any);
    final q = await makeQueue();
    expect(await pick(q, 'k1'), SubmitOutcome.queued);
  });

  test('a 4xx is rejected to the caller and nothing is queued', () async {
    env.adapter.onPost(
        '/trips/pickStudent',
        (s) => s.reply(
            400, {'message': 'Already picked', 'code': 'ALREADY_PICKED'}),
        data: Matchers.any);
    final q = await makeQueue();
    await expectLater(
        pick(q, 'k1'),
        throwsA(
            isA<ApiError>().having((e) => e.code, 'code', 'ALREADY_PICKED')));
    expect(q.pending.value, 0);
  });

  test('while something is waiting, new actions join the back (FIFO)',
      () async {
    final sent = <String>[];
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: pickBody('k1'));
    final q = await makeQueue();
    expect(await pick(q, 'k1'), SubmitOutcome.queued);

    // The server is reachable again, but k1 must go before k2.
    env.dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      sent.add((o.data as Map)['kidId'] as String);
      h.next(o);
    }));
    env.adapter.reset();
    env.adapter
      ..onPost('/trips/pickStudent', (s) => s.reply(200, {}),
          data: pickBody('k1'))
      ..onPost('/trips/pickStudent', (s) => s.reply(200, {}),
          data: pickBody('k2'));
    expect(
        await pick(q, 'k2'), SubmitOutcome.queued); // overtaking is not allowed
    await settle(); // the queue flushes itself right after queueing
    expect(sent, ['k1', 'k2']);
    expect(q.pending.value, 0);
  });

  test('flush stops at the first failure and keeps the rest in order',
      () async {
    final q = await makeQueue();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: Matchers.any);
    await pick(q, 'k1');
    await pick(q, 'k2');
    await settle();
    expect(q.pending.value, 2);
    expect(await q.flush(), isFalse);
    expect(q.pending.value, 2);
  });

  test('flush drops items the server rejects, and keeps going', () async {
    final q = await makeQueue();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: Matchers.any);
    await pick(q, 'k1');
    await pick(q, 'k2');
    await settle(); // let the automatic flush finish (still offline)

    env.adapter.reset();
    env.adapter
      ..onPost('/trips/pickStudent', (s) => s.reply(400, {'message': 'no'}),
          data: pickBody('k1'))
      ..onPost('/trips/pickStudent', (s) => s.reply(200, {}),
          data: pickBody('k2'));
    final synced = expectLater(q.onSynced, emits(anything));
    expect(await q.flush(), isTrue);
    await synced;
    expect(q.pending.value, 0);
  });

  test('a 401 keeps the queue for after the next login', () async {
    final q = await makeQueue();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: Matchers.any);
    await pick(q, 'k1');
    env.adapter.reset();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.reply(401, {'message': 'expired'}),
        data: Matchers.any);
    expect(await q.flush(), isFalse);
    expect(q.pending.value, 1);
  });

  test('coming back online flushes by itself', () async {
    final q = await makeQueue();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: pickBody('k1'));
    await pick(q, 'k1');
    env.adapter.reset();
    env.adapter.onPost('/trips/pickStudent', (s) => s.reply(200, {}),
        data: pickBody('k1'));
    online.add(true);
    await settle();
    expect(q.pending.value, 0);
  });

  group('location points', () {
    test(
        'only the newest queued point per trip is kept, and they are not counted as pending actions',
        () async {
      final q = await makeQueue();
      env.adapter.onPost(
          '/trips/updateLocation/t1', (s) => s.throws(0, connectionError('/x')),
          data: Matchers.any);
      await location(q, 1);
      await location(q, 2);
      await location(q, 3);
      expect(q.pending.value, 0); // location noise is not a driver action
      final sent = <double>[];
      env.dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
        sent.add((o.data as Map)['lat'] as double);
        h.next(o);
      }));
      env.adapter.reset();
      env.adapter.onPost('/trips/updateLocation/t1', (s) => s.reply(200, {}),
          data: Matchers.any);
      await q.flush();
      expect(sent, [3.0]);
    });

    test('a point older than 3 minutes is dropped, not replayed', () async {
      final q = await makeQueue();
      env.adapter.onPost(
          '/trips/updateLocation/t1', (s) => s.throws(0, connectionError('/x')),
          data: Matchers.any);
      await location(q, 1);
      now = now.add(const Duration(minutes: 4));
      var requests = 0;
      env.dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
        requests++;
        h.next(o);
      }));
      env.adapter.reset();
      env.adapter.onPost('/trips/updateLocation/t1', (s) => s.reply(200, {}),
          data: Matchers.any);
      expect(await q.flush(), isTrue);
      expect(requests, 0);
    });

    test('while a pick is waiting, a new location point is queued behind it',
        () async {
      final q = await makeQueue();
      env.adapter.onPost(
          '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
          data: Matchers.any);
      await pick(q, 'k1');
      expect(await location(q, 5), SubmitOutcome.queued);
    });

    test('a fresh point that is sent also removes an older queued one',
        () async {
      final q = await makeQueue();
      env.adapter.onPost(
          '/trips/updateLocation/t1', (s) => s.throws(0, connectionError('/x')),
          data: {'lat': 1.0, 'lng': 67.0});
      await location(q, 1); // queued
      // Offline items count only actions, so the next point is sent directly.
      env.adapter.reset();
      env.adapter.onPost('/trips/updateLocation/t1', (s) => s.reply(200, {}),
          data: {'lat': 2.0, 'lng': 67.0});
      expect(await location(q, 2), SubmitOutcome.sent);
      var requests = 0;
      env.dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
        requests++;
        h.next(o);
      }));
      expect(await q.flush(), isTrue);
      expect(requests, 0); // the old point was dropped when the new one landed
    });
  });

  test('clear empties the queue', () async {
    final q = await makeQueue();
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: Matchers.any);
    await pick(q, 'k1');
    await q.clear();
    expect(q.pending.value, 0);
    expect(q.pendingKidStatuses(null), isEmpty);
  });

  test('a drop is reported as dropped and the last status per kid wins',
      () async {
    final q = await makeQueue();
    env.adapter
      ..onPost('/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
          data: Matchers.any)
      ..onPost('/trips/dropStudentForHome',
          (s) => s.throws(0, connectionError('/x')),
          data: Matchers.any);
    await pick(q, 'k1');
    await q.submit(
        kind: SyncKind.drop,
        path: '/trips/dropStudentForHome',
        body: {'tripId': 't1', 'kidId': 'k1', 'lat': 1.0, 'long': 2.0},
        tripId: 't1',
        kidId: 'k1');
    expect(q.pendingKidStatuses('t1'), {'k1': 'dropped'});
  });

  test('the queue survives a restart (same box)', () async {
    final name = 'persist${boxCounter++}';
    env.adapter.onPost(
        '/trips/pickStudent', (s) => s.throws(0, connectionError('/x')),
        data: Matchers.any);
    final first = SyncQueue(env.client,
        onlineChanges: () => online.stream,
        clock: () => now,
        retryEvery: const Duration(hours: 1),
        boxName: name);
    await first.init();
    await pick(first, 'k1');
    await settle(); // the automatic flush finishes (still offline)
    await first.dispose();
    await Hive.box(name).close();

    final second = SyncQueue(env.client,
        onlineChanges: () => online.stream,
        clock: () => now,
        retryEvery: const Duration(hours: 1),
        boxName: name);
    await second.init();
    addTearDown(second.dispose);
    expect(second.pending.value, 1);
    expect(second.pendingKidStatuses('t1'), {'k1': 'picked'});
    await settle(); // init() started a flush; let it finish before the box closes
  });
}
