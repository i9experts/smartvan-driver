import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_compass.dart';
import 'van_pose_animator.dart';

/// Keeps a map's camera on the van while [following], and lets the user take
/// over: [userMoved] (a touch on the map) stops following, [recenter] resumes.
/// Listen to it to show or hide a "Re-center" button.
class FollowCameraController extends ChangeNotifier implements CompassFollow {
  FollowCameraController({DateTime Function()? clock})
      : _now = clock ?? DateTime.now;

  bool _following = true;
  bool _headingUp = false;

  /// While a camera animation runs (compass tap), the camera is not moved.
  DateTime? _holdUntil;
  final DateTime Function() _now;

  /// The bearing held while the van is too slow for its heading to mean
  /// anything.
  double? _holdBearing;
  Future<void> Function(LatLng, double)? _moveHeading;
  Future<void> Function(LatLng, double)? _animateHeading;
  VanPose? _last;
  Future<void> Function(LatLng)? _move;
  Future<void> Function(LatLng)? _animate;

  @override
  bool get following => _following;

  /// Following with the map turned to the van's heading.
  @override
  bool get headingUp => _following && _headingUp;

  /// Below this speed (m/s) the van's heading is noise: the camera keeps its
  /// bearing.
  static const minHeadingSpeed = 1.0;

  /// Hooks up a real map: [move] jumps the camera (called every frame while
  /// the van animates), [animate] glides it (used by [recenter]).
  ///
  /// [moveHeading] / [animateHeading] do the same with the camera's bearing
  /// set too (heading-up mode).
  void attach({
    required Future<void> Function(LatLng) move,
    required Future<void> Function(LatLng) animate,
    Future<void> Function(LatLng, double)? moveHeading,
    Future<void> Function(LatLng, double)? animateHeading,
  }) {
    _move = move;
    _animate = animate;
    _moveHeading = moveHeading;
    _animateHeading = animateHeading;
  }

  /// [zoom] gives the camera's current zoom, kept while the bearing turns.
  void attachMap(GoogleMapController map, {double Function()? zoom}) {
    CameraUpdate headed(LatLng p, double bearing) =>
        CameraUpdate.newCameraPosition(CameraPosition(
            target: p, zoom: zoom?.call() ?? 15, bearing: bearing, tilt: 0));
    attach(
      move: (p) => map.moveCamera(CameraUpdate.newLatLng(p)),
      animate: (p) => map.animateCamera(CameraUpdate.newLatLng(p)),
      moveHeading: (p, b) => map.moveCamera(headed(p, b)),
      animateHeading: (p, b) => map.animateCamera(headed(p, b)),
    );
  }

  void detach() {
    _move = null;
    _animate = null;
    _moveHeading = null;
    _animateHeading = null;
  }

  /// The van is now drawn at [pose]; follows it when following — in
  /// heading-up mode the camera turns to the van's heading too (unless the
  /// van is slower than [minHeadingSpeed], then the bearing is held).
  void onPose(VanPose pose, {double? speedMetersPerSecond}) {
    _last = pose;
    if (!_following || _held) return;
    if (_headingUp && _moveHeading != null) {
      _runHeading(
          _moveHeading, pose.position, _bearingFor(pose, speedMetersPerSecond));
    } else {
      _run(_move, pose.position);
    }
  }

  bool get _held => _holdUntil != null && _now().isBefore(_holdUntil!);

  @override
  void holdCamera(Duration duration) => _holdUntil = _now().add(duration);

  /// Heading-up: glide the camera to the van's heading from now on. Does
  /// nothing unless following.
  @override
  void enterHeadingUp() {
    if (!_following || _headingUp) return;
    _headingUp = true;
    _holdBearing = null;
    holdCamera(compassAnimation);
    final last = _last;
    if (last != null && _animateHeading != null) {
      _runHeading(_animateHeading, last.position, _bearingFor(last, null));
    }
    notifyListeners();
  }

  /// Back to a north-up map; the caller points the camera north.
  @override
  void exitHeadingUp() {
    if (!_headingUp) return;
    _headingUp = false;
    _holdBearing = null;
    notifyListeners();
  }

  double _bearingFor(VanPose pose, double? speed) {
    final slow = speed != null && speed < minHeadingSpeed;
    if (!slow || _holdBearing == null) _holdBearing = pose.rotation;
    return _holdBearing!;
  }

  /// The user touched the map: stop following (and heading-up).
  void userMoved() {
    if (!_following) return;
    _following = false;
    _headingUp = false;
    _holdBearing = null;
    notifyListeners();
  }

  /// Follow again, gliding back to the van.
  void recenter() {
    final wasFollowing = _following;
    _following = true;
    final last = _last;
    if (last != null) _run(_animate, last.position);
    if (!wasFollowing) notifyListeners();
  }

  void _runHeading(Future<void> Function(LatLng, double)? action, LatLng to,
      double bearing) {
    action?.call(to, bearing).catchError((Object e) {
      debugPrint('[FollowCamera] camera move failed: $e');
    });
  }

  void _run(Future<void> Function(LatLng)? action, LatLng to) {
    // A map that is being torn down can refuse; the next frame tries again.
    action?.call(to).catchError((Object e) {
      debugPrint('[FollowCamera] camera move failed: $e');
    });
  }
}
