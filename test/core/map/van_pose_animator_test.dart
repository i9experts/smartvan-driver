import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/core/map/geo_math.dart';
import 'package:smartvan_driver/core/map/van_pose_animator.dart';

class _Vsync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  const start = LatLng(24.8607, 67.0011);
  // ~11 m north of start.
  const north = LatLng(24.8608, 67.0011);
  // ~11 m east of north.
  const east = LatLng(24.8608, 67.0012);

  late VanPoseAnimator animator;

  setUp(() => animator = VanPoseAnimator(vsync: _Vsync()));
  tearDown(() => animator.dispose());

  testWidgets('the first fix is shown at once, facing north', (tester) async {
    expect(animator.pose.value, isNull);
    animator.update(start);
    expect(animator.pose.value, const VanPose(start, 0));
  });

  testWidgets('a new fix is reached in about a second, in between on the way',
      (tester) async {
    animator.update(start);
    animator.update(north, speedMetersPerSecond: 8);
    await tester.pump(); // starts the ticker
    await tester.pump(const Duration(milliseconds: 500));
    final mid = animator.pose.value!;
    expect(mid.position.latitude, greaterThan(start.latitude));
    expect(mid.position.latitude, lessThan(north.latitude));
    expect(mid.position.latitude,
        closeTo((start.latitude + north.latitude) / 2, 0.00002));
    await tester.pump(const Duration(milliseconds: 600));
    expect(animator.pose.value!.position, north);
    expect(animator.pose.value!.rotation, closeTo(0, 0.01)); // heading north
  });

  testWidgets('it turns to the direction of travel', (tester) async {
    animator.update(start);
    animator.update(north, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    animator.update(east, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.rotation, closeTo(90, 0.5));
  });

  testWidgets('turning from 350° to 10° passes through north', (tester) async {
    // Heading ~350° (north-north-west), then ~10° (north-north-east).
    const a = LatLng(24.8607, 67.0011);
    const b = LatLng(24.8609, 67.00105); // slightly west of north
    const c = LatLng(24.8611, 67.00115); // slightly east of north
    animator.update(a);
    animator.update(b, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    final first = animator.pose.value!.rotation;
    expect(first, greaterThan(300));
    animator.update(c, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final mid = animator.pose.value!.rotation;
    // Never swings through the south half while turning.
    expect(mid > 300 || mid < 60, isTrue, reason: 'rotation $mid');
    await tester.pump(const Duration(milliseconds: 600));
    expect(animator.pose.value!.rotation, lessThan(60));
  });

  testWidgets('at very low speed the old rotation is kept', (tester) async {
    animator.update(start);
    animator.update(north, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.rotation, closeTo(0, 0.01));
    animator.update(east, speedMetersPerSecond: 0.2); // crawling: GPS noise
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.position, east);
    expect(animator.pose.value!.rotation, closeTo(0, 0.01));
  });

  testWidgets('without a speed reading, a tiny move does not turn the van',
      (tester) async {
    animator.update(start);
    animator.update(north, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    // ~1 m east: below the minimum move.
    animator.update(const LatLng(24.8608, 67.001109));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.rotation, closeTo(0, 0.01));
    // A real move without a speed reading turns it.
    animator.update(const LatLng(24.8608, 67.0013));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.rotation, closeTo(90, 1));
  });

  testWidgets('a jump over 200 m is placed, not animated', (tester) async {
    animator.update(start);
    const far = LatLng(24.8707, 67.0011); // ~1.1 km north
    expect(distanceMeters(start, far), greaterThan(200));
    animator.update(far, speedMetersPerSecond: 8);
    // At once, before any frame.
    expect(animator.pose.value!.position, far);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(animator.pose.value!.position, far);
  });

  testWidgets('a fix just under 200 m is still animated', (tester) async {
    animator.update(start);
    const near = LatLng(24.8624, 67.0011); // ~190 m north
    expect(distanceMeters(start, near), lessThan(200));
    animator.update(near, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final p = animator.pose.value!.position;
    expect(p.latitude, greaterThan(start.latitude));
    expect(p.latitude, lessThan(near.latitude));
    await tester.pump(const Duration(seconds: 2)); // let it finish
  });

  testWidgets('a fix during an animation restarts from where the van is',
      (tester) async {
    animator.update(start);
    animator.update(north, speedMetersPerSecond: 8);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final shown = animator.pose.value!.position;
    animator.update(east, speedMetersPerSecond: 8);
    await tester.pump();
    // No snap back to start or ahead to north.
    expect(distanceMeters(animator.pose.value!.position, shown), lessThan(2));
    await tester.pump(const Duration(milliseconds: 1100));
    expect(animator.pose.value!.position, east);
  });

  testWidgets('the same fix twice does nothing', (tester) async {
    animator.update(start);
    var changes = 0;
    animator.pose.addListener(() => changes++);
    animator.update(start);
    expect(changes, 0);
  });
}
