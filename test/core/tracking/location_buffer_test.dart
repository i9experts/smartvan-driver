import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:smartvan_driver/core/tracking/location_buffer.dart';
import 'package:smartvan_driver/core/tracking/tracked_point.dart';

TrackedPoint pt(int i, {double? speed}) => TrackedPoint(
    lat: 24 + i / 1000,
    lng: 67,
    time: DateTime.utc(2026, 10, 13, 12, 0, i),
    speed: speed);

void main() {
  group('TrackedPoint', () {
    test('batch json: ISO UTC time, speed only when known', () {
      expect(pt(1, speed: 5).toBatchJson(), {
        'lat': 24.001,
        'lng': 67.0,
        'time': '2026-10-13T12:00:01.000Z',
        'speed': 5.0,
      });
      expect(pt(1).toBatchJson().containsKey('speed'), isFalse);
      expect(pt(1, speed: -1).toBatchJson().containsKey('speed'), isFalse);
    });

    test('map round trip keeps everything', () {
      final p = TrackedPoint(
          lat: 1,
          lng: 2,
          time: DateTime.fromMillisecondsSinceEpoch(1700000000000),
          speed: 3,
          heading: 90,
          accuracy: 12,
          synthetic: true);
      expect(TrackedPoint.fromMap(p.toMap()), p);
    });

    test('a broken map is null', () {
      expect(TrackedPoint.fromMap({'lat': 1}), isNull);
      expect(TrackedPoint.fromMap('x'), isNull);
    });

    test('heartbeat repeats the place now, standing still', () {
      final now = DateTime.utc(2026, 10, 13, 13);
      final h = pt(1, speed: 9).heartbeat(now);
      expect(h.lat, 24.001);
      expect(h.time, now);
      expect(h.speed, 0);
      expect(h.synthetic, isTrue);
    });
  });

  void bufferContract(String name, Future<LocationBuffer> Function() make) {
    group(name, () {
      late LocationBuffer buffer;
      setUp(() async => buffer = await make());

      test('oldest first, per trip, limited', () async {
        for (var i = 0; i < 5; i++) {
          await buffer.add('a', pt(i));
        }
        await buffer.add('b', pt(99));
        final got = await buffer.next('a', 3);
        expect(got.map((b) => b.point.time.second), [0, 1, 2]);
        expect(await buffer.count('a'), 5);
        expect(await buffer.count('b'), 1);
      });

      test('removed points are gone, the rest keep their order', () async {
        for (var i = 0; i < 4; i++) {
          await buffer.add('a', pt(i));
        }
        final first = await buffer.next('a', 2);
        await buffer.remove(first.map((b) => b.key));
        final rest = await buffer.next('a', 10);
        expect(rest.map((b) => b.point.time.second), [2, 3]);
      });

      test('clear drops one trip only', () async {
        await buffer.add('a', pt(1));
        await buffer.add('b', pt(2));
        await buffer.clear('a');
        expect(await buffer.count('a'), 0);
        expect(await buffer.count('b'), 1);
      });
    });
  }

  bufferContract('MemoryLocationBuffer', () async => MemoryLocationBuffer());

  group('HiveLocationBuffer', () {
    late Directory dir;
    var n = 0;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('buffer_test');
      Hive.init(dir.path);
    });

    tearDown(() async {
      await Hive.close();
      await dir.delete(recursive: true);
    });

    bufferContract(
        'contract', () async => HiveLocationBuffer.open(name: 'b${n++}'));

    test('survives a restart (box closed and opened again)', () async {
      var buffer = await HiveLocationBuffer.open(name: 'persist');
      await buffer.add('a', pt(1, speed: 4));
      await buffer.add('a', pt(2));
      await Hive.close();
      Hive.init(dir.path);
      buffer = await HiveLocationBuffer.open(name: 'persist');
      final got = await buffer.next('a', 10);
      expect(got.map((b) => b.point.time.second), [1, 2]);
      expect(got.first.point.speed, 4);
    });

    test('over the cap the oldest points go', () async {
      final box = await Hive.openBox<Map<dynamic, dynamic>>('capped');
      final buffer = HiveLocationBuffer(box, maxPoints: 3);
      for (var i = 0; i < 5; i++) {
        await buffer.add('a', pt(i));
      }
      final got = await buffer.next('a', 10);
      expect(got.map((b) => b.point.time.second), [2, 3, 4]);
    });

    test('an unreadable entry is dropped, not stuck at the front', () async {
      final box = await Hive.openBox<Map<dynamic, dynamic>>('broken');
      await box.add({'trip': 'a', 'lat': 'x'});
      final buffer = HiveLocationBuffer(box);
      await buffer.add('a', pt(1));
      final got = await buffer.next('a', 10);
      expect(got, hasLength(1));
      expect(box.length, 1);
    });
  });
}
