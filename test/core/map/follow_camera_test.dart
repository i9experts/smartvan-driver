import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/core/map/follow_camera.dart';
import 'package:smartvan_driver/core/map/van_pose_animator.dart';

void main() {
  const a = LatLng(1, 1);
  const b = LatLng(2, 2);
  late FollowCameraController follow;
  late List<LatLng> moved;
  late List<LatLng> animated;

  setUp(() {
    follow = FollowCameraController();
    moved = [];
    animated = [];
    follow.attach(
      move: (p) async => moved.add(p),
      animate: (p) async => animated.add(p),
    );
  });

  test('follows the van by moving the camera on every frame', () {
    expect(follow.following, isTrue);
    follow.onPose(const VanPose(a, 0));
    follow.onPose(const VanPose(b, 0));
    expect(moved, [a, b]);
    expect(animated, isEmpty);
  });

  test('a touch on the map stops following and tells listeners', () {
    var notified = 0;
    follow.addListener(() => notified++);
    follow.userMoved();
    expect(follow.following, isFalse);
    expect(notified, 1);
    follow.onPose(const VanPose(a, 0));
    expect(moved, isEmpty);
    follow.userMoved(); // already stopped: no second notification
    expect(notified, 1);
  });

  test('recenter glides to the latest van position and follows again', () {
    follow.onPose(const VanPose(a, 0));
    follow.userMoved();
    follow.onPose(const VanPose(b, 0)); // not followed, but remembered
    var notified = 0;
    follow.addListener(() => notified++);
    follow.recenter();
    expect(follow.following, isTrue);
    expect(animated, [b]);
    expect(notified, 1);
    follow.onPose(const VanPose(a, 0));
    expect(moved.last, a);
  });

  test('recenter before any fix just follows again', () {
    follow.userMoved();
    follow.recenter();
    expect(follow.following, isTrue);
    expect(animated, isEmpty);
  });

  test('a map that refuses a move does not crash', () async {
    follow.attach(
      move: (_) => Future<void>.error(StateError('gone')),
      animate: (_) async {},
    );
    follow.onPose(const VanPose(a, 0));
    await Future<void>.delayed(Duration.zero);
  });

  test('detached, poses are only remembered', () {
    follow.detach();
    follow.onPose(const VanPose(a, 0));
    follow.recenter();
    expect(moved, isEmpty);
    expect(animated, isEmpty);
  });
}
