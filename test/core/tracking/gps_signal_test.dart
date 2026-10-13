import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/tracking/gps_signal.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 13, 12);
  DateTime after(int s) => t0.add(Duration(seconds: s));

  bool weak({
    int now = 0,
    int? fixAt,
    int? startedAt = 0,
    double? accuracy,
    double? speed,
  }) =>
      isGpsWeak(
        now: after(now),
        lastRealFixAt: fixAt == null ? null : after(fixAt),
        trackingStartedAt: startedAt == null ? null : after(startedAt),
        accuracy: accuracy,
        lastSpeed: speed,
      );

  test('a fresh, accurate fix is fine', () {
    expect(weak(now: 3, fixAt: 2, accuracy: 8, speed: 9), isFalse);
  });

  test('accuracy worse than 50 m is weak (even if fresh)', () {
    expect(weak(now: 3, fixAt: 2, accuracy: 51, speed: 9), isTrue);
    expect(weak(now: 3, fixAt: 2, accuracy: 50, speed: 9), isFalse);
  });

  test('a moving van with no fix for 20 s is weak', () {
    expect(weak(now: 21, fixAt: 2, speed: 9), isFalse);
    expect(weak(now: 22, fixAt: 2, speed: 9), isTrue);
  });

  test('unknown speed counts as moving', () {
    expect(weak(now: 30, fixAt: 2), isTrue);
  });

  test('a van standing still sends no fixes — that is not weak', () {
    expect(weak(now: 300, fixAt: 2, speed: 0), isFalse);
    expect(weak(now: 300, fixAt: 2, speed: 0.4), isFalse);
  });

  test('a still van whose GPS says it is inaccurate is still weak', () {
    expect(weak(now: 300, fixAt: 2, speed: 0, accuracy: 120), isTrue);
  });

  test('no fix at all since tracking began: weak after 20 s', () {
    expect(weak(now: 19, fixAt: null, startedAt: 0), isFalse);
    expect(weak(now: 20, fixAt: null, startedAt: 0), isTrue);
  });

  test('not tracking: never weak', () {
    expect(weak(now: 500, fixAt: null, startedAt: null), isFalse);
  });
}
