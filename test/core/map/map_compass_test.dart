import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/core/map/follow_camera.dart';
import 'package:smartvan_driver/core/map/map_compass.dart';
import 'package:smartvan_driver/core/map/van_pose_animator.dart';

void main() {
  group('compassTapAction', () {
    CompassTapAction act({
      double bearing = 0,
      bool following = true,
      bool headingUp = false,
      bool allowed = true,
    }) =>
        compassTapAction(
            bearing: bearing,
            following: following,
            headingUp: headingUp,
            headingUpAllowed: allowed);

    test('a turned map first goes north, even while following', () {
      expect(act(bearing: 90), CompassTapAction.pointNorth);
      expect(act(bearing: 359), CompassTapAction.pointNorth);
    });

    test('north up and following: the next tap is heading-up', () {
      expect(act(), CompassTapAction.headingUp);
      expect(act(bearing: 0.2), CompassTapAction.headingUp);
      expect(act(bearing: 359.8), CompassTapAction.headingUp);
    });

    test('heading-up: a tap goes back to north', () {
      expect(act(bearing: 140, headingUp: true), CompassTapAction.pointNorth);
    });

    test('not following: only north (nothing to turn with)', () {
      expect(act(following: false), CompassTapAction.pointNorth);
    });

    test('a map without heading-up (the parent) is always north', () {
      expect(act(allowed: false), CompassTapAction.pointNorth);
    });
  });

  group('MapCompassController', () {
    late FollowCameraController follow;
    late MapCompassController compass;
    late List<CameraPosition> animated;
    late List<(LatLng, double)> headed;

    setUp(() {
      follow = FollowCameraController();
      animated = [];
      headed = [];
      follow.attach(
        move: (_) async {},
        animate: (_) async {},
        moveHeading: (p, b) async => headed.add((p, b)),
        animateHeading: (p, b) async => headed.add((p, b)),
      );
      compass = MapCompassController(follow: follow)
        ..attach(animateTo: (p) async => animated.add(p));
    });

    tearDown(() {
      compass.dispose();
      follow.dispose();
    });

    test('takes bearing and zoom from the camera moves and tells listeners',
        () {
      var notified = 0;
      compass.addListener(() => notified++);
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 75));
      expect(compass.bearing, 75);
      expect(compass.zoom, 16);
      expect(notified, 1);
    });

    test('tap on a turned map: north up, same target and zoom, tilt 0', () {
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 75, tilt: 30));
      compass.onPressed();
      expect(animated.single,
          const CameraPosition(target: LatLng(24.9, 67.0), zoom: 16));
    });

    test('second tap (north, following): heading-up with the van\'s heading',
        () {
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 0));
      follow.onPose(const VanPose(LatLng(24.9, 67.0), 120));
      compass.onPressed();
      expect(compass.headingUp, isTrue);
      expect(headed.last, (const LatLng(24.9, 67.0), 120.0));
      expect(animated, isEmpty, reason: 'heading-up moves the camera itself');
    });

    test('tap in heading-up: back to north up', () {
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 0));
      compass.onPressed(); // heading-up
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 120));
      compass.onPressed();
      expect(compass.headingUp, isFalse);
      expect(animated.single.bearing, 0);
    });

    test('the user touching the map ends heading-up and following', () {
      compass.onCameraMove(const CameraPosition(
          target: LatLng(24.9, 67.0), zoom: 16, bearing: 0));
      compass.onPressed();
      expect(compass.headingUp, isTrue);
      follow.userMoved();
      expect(compass.headingUp, isFalse);
      expect(follow.following, isFalse);
    });

    test('nextAction follows the state (for the button label)', () {
      compass.onCameraMove(
          const CameraPosition(target: LatLng(0, 0), zoom: 15, bearing: 0));
      expect(compass.nextAction, CompassTapAction.headingUp);
      compass.onCameraMove(
          const CameraPosition(target: LatLng(0, 0), zoom: 15, bearing: 50));
      expect(compass.nextAction, CompassTapAction.pointNorth);
    });

    test('a map without a follow camera: always north', () {
      final plain = MapCompassController()
        ..attach(animateTo: (p) async => animated.add(p));
      plain.onCameraMove(
          const CameraPosition(target: LatLng(1, 2), zoom: 14, bearing: 0));
      plain.onPressed();
      expect(plain.headingUp, isFalse);
      expect(animated.single.bearing, 0);
      plain.dispose();
    });

    test('a refusing map does not crash', () async {
      compass.attach(animateTo: (_) => Future<void>.error(StateError('gone')));
      compass.onCameraMove(
          const CameraPosition(target: LatLng(1, 2), zoom: 14, bearing: 90));
      compass.onPressed();
      await Future<void>.delayed(Duration.zero);
    });

    test('listeners of the follow camera are forwarded', () {
      var notified = 0;
      compass.addListener(() => notified++);
      follow.userMoved();
      expect(notified, 1);
    });
  });

  group('FollowCameraController heading-up', () {
    late FollowCameraController follow;
    late List<(LatLng, double)> headed;
    late List<LatLng> moved;

    setUp(() {
      follow = FollowCameraController();
      headed = [];
      moved = [];
      follow.attach(
        move: (p) async => moved.add(p),
        animate: (_) async {},
        moveHeading: (p, b) async => headed.add((p, b)),
        animateHeading: (p, b) async => headed.add((p, b)),
      );
    });

    test('off by default: the camera only follows the position', () {
      follow.onPose(const VanPose(LatLng(1, 1), 90));
      expect(moved, [const LatLng(1, 1)]);
      expect(headed, isEmpty);
      expect(follow.headingUp, isFalse);
    });

    test('on: every frame moves the camera with the van\'s heading', () {
      follow.onPose(const VanPose(LatLng(1, 1), 90));
      follow.enterHeadingUp();
      follow.onPose(const VanPose(LatLng(1, 2), 100), speedMetersPerSecond: 8);
      follow.onPose(const VanPose(LatLng(1, 3), 110), speedMetersPerSecond: 8);
      expect(headed.map((h) => h.$2), [90.0, 100.0, 110.0]);
      expect(moved, [const LatLng(1, 1)], reason: 'no plain moves any more');
    });

    test('a van barely moving keeps the old bearing', () {
      follow.enterHeadingUp();
      follow.onPose(const VanPose(LatLng(1, 1), 100), speedMetersPerSecond: 9);
      follow.onPose(const VanPose(LatLng(1, 1), 200),
          speedMetersPerSecond: 0.3);
      follow.onPose(const VanPose(LatLng(1, 1), 300),
          speedMetersPerSecond: 0.9);
      expect(headed.map((h) => h.$2), [100.0, 100.0, 100.0]);
      follow.onPose(const VanPose(LatLng(1, 1), 150), speedMetersPerSecond: 2);
      expect(headed.last.$2, 150);
    });

    test('unknown speed counts as moving', () {
      follow.enterHeadingUp();
      follow.onPose(const VanPose(LatLng(1, 1), 40));
      follow.onPose(const VanPose(LatLng(1, 1), 70));
      expect(headed.map((h) => h.$2), [40.0, 70.0]);
    });

    test('entering glides to the van\'s heading at once', () {
      follow.onPose(const VanPose(LatLng(1, 1), 250));
      follow.enterHeadingUp();
      expect(headed.single, (const LatLng(1, 1), 250.0));
    });

    test('cannot start while not following', () {
      follow.userMoved();
      follow.enterHeadingUp();
      expect(follow.headingUp, isFalse);
    });

    test('a touch on the map ends it', () {
      follow.enterHeadingUp();
      follow.userMoved();
      expect(follow.headingUp, isFalse);
      follow.onPose(const VanPose(LatLng(1, 1), 90));
      expect(headed, isEmpty);
    });

    test('Re-center after a touch follows north-up again', () {
      follow.enterHeadingUp();
      follow.userMoved();
      follow.recenter();
      expect(follow.following, isTrue);
      expect(follow.headingUp, isFalse);
    });

    test('exitHeadingUp is back to plain following', () {
      follow.enterHeadingUp();
      follow.exitHeadingUp();
      follow.onPose(const VanPose(LatLng(1, 1), 90));
      expect(moved, [const LatLng(1, 1)]);
      expect(follow.following, isTrue);
    });

    test('notifies when heading-up starts and ends', () {
      var notified = 0;
      follow.addListener(() => notified++);
      follow.enterHeadingUp();
      follow.enterHeadingUp(); // already on
      follow.exitHeadingUp();
      follow.exitHeadingUp(); // already off
      expect(notified, 2);
    });

    test('without heading hooks it falls back to plain following', () {
      final plain = FollowCameraController()
        ..attach(move: (p) async => moved.add(p), animate: (_) async {});
      plain.enterHeadingUp();
      plain.onPose(const VanPose(LatLng(5, 5), 10));
      expect(moved, [const LatLng(5, 5)]);
    });
  });
}
