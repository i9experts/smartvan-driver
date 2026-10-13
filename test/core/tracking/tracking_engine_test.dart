import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';
import 'package:smartvan_driver/core/tracking/tracking_engine.dart';
import 'package:smartvan_driver/core/tracking/tracking_uploader.dart';

class FakeSink implements PointSink {
  final submitted = <(TrackedPoint, bool)>[];
  int flushes = 0;
  Completer<void>? hold;

  @override
  Future<void> submit(TrackedPoint point, {bool force = false}) async {
    await hold?.future;
    submitted.add((point, force));
  }

  @override
  Future<void> flush() async => flushes++;
}

void main() {
  late StreamController<TrackedPoint> gps;
  late FakeSink sink;
  late List<TrackedPoint> reported;

  TrackedPoint pt(int i, {double? speed = 6}) => TrackedPoint(
      lat: 24 + i / 1000,
      lng: 67,
      time: DateTime.utc(2026, 10, 13, 12).add(Duration(seconds: i)),
      speed: speed);

  setUp(() {
    gps = StreamController<TrackedPoint>.broadcast();
    sink = FakeSink();
    reported = [];
  });

  final start = DateTime.utc(2026, 10, 13, 12);

  TrackingEngine make(FakeAsync async,
          {Future<TrackedPoint?> Function()? seed}) =>
      TrackingEngine(
          positions: gps.stream,
          sink: sink,
          // DateTime.now() is not faked by fakeAsync.
          clock: () => start.add(async.elapsed),
          seed: seed,
          onFix: reported.add);

  test('every real fix goes to the sink and is reported', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      gps.add(pt(1));
      gps.add(pt(2));
      async.flushMicrotasks();
      expect(sink.submitted.map((s) => s.$1), [pt(1), pt(2)]);
      expect(sink.submitted.every((s) => !s.$2), isTrue, reason: 'not forced');
      expect(reported, [pt(1), pt(2)]);
      expect(engine.lastFix, pt(2));
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('a van standing still repeats its place every 5 s with speed 0', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      gps.add(pt(1));
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 5));
      expect(sink.submitted, hasLength(2));
      final beat = sink.submitted.last;
      expect(beat.$1.synthetic, isTrue);
      expect(beat.$1.speed, 0);
      expect(beat.$1.lat, pt(1).lat);
      expect(beat.$2, isTrue, reason: 'forced past the 5 s throttle');
      expect(reported.last.synthetic, isTrue);
      async.elapse(const Duration(seconds: 10));
      expect(sink.submitted, hasLength(4));
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('a moving van sends no heartbeats', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      for (var s = 1; s <= 20; s++) {
        gps.add(pt(s));
        async.elapse(const Duration(seconds: 1));
      }
      expect(sink.submitted.where((s) => s.$1.synthetic), isEmpty);
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('no heartbeat before the first reading', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      async.elapse(const Duration(seconds: 30));
      expect(sink.submitted, isEmpty);
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('a van that is standing still at the start is located once', () {
    fakeAsync((async) {
      final engine = make(async, seed: () async => pt(9));
      engine.start();
      async.flushMicrotasks();
      expect(sink.submitted.single.$1, pt(9));
      async.elapse(const Duration(seconds: 5));
      expect(sink.submitted, hasLength(2), reason: 'the heartbeat can begin');
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('the seed is ignored when a real fix already came', () {
    fakeAsync((async) {
      final slow = Completer<TrackedPoint?>();
      final engine = make(async, seed: () => slow.future);
      engine.start();
      gps.add(pt(1));
      async.flushMicrotasks();
      slow.complete(pt(9));
      async.flushMicrotasks();
      expect(sink.submitted.map((s) => s.$1), [pt(1)]);
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('a failing seed does not stop tracking', () {
    fakeAsync((async) {
      final engine = make(async, seed: () async => throw StateError('no gps'));
      engine.start();
      async.flushMicrotasks();
      gps.add(pt(1));
      async.flushMicrotasks();
      expect(sink.submitted, hasLength(1));
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('uploads go one at a time, in order', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      sink.hold = Completer<void>();
      gps.add(pt(1));
      gps.add(pt(2));
      async.flushMicrotasks();
      expect(sink.submitted, isEmpty, reason: 'the first one is still going');
      sink.hold!.complete();
      async.flushMicrotasks();
      expect(sink.submitted.map((s) => s.$1), [pt(1), pt(2)]);
      engine.stop();
      async.flushMicrotasks();
    });
  });

  test('start flushes leftovers; stop flushes once more and goes quiet', () {
    fakeAsync((async) {
      final engine = make(async);
      engine.start();
      async.flushMicrotasks();
      expect(sink.flushes, 1);
      expect(engine.running, isTrue);
      gps.add(pt(1));
      async.flushMicrotasks();
      engine.stop();
      async.flushMicrotasks();
      expect(sink.flushes, 2);
      expect(engine.running, isFalse);
      gps.add(pt(2));
      async.elapse(const Duration(seconds: 30));
      expect(sink.submitted.map((s) => s.$1), [pt(1)]);
    });
  });
}
