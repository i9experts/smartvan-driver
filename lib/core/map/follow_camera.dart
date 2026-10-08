import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'van_pose_animator.dart';

/// Keeps a map's camera on the van while [following], and lets the user take
/// over: [userMoved] (a touch on the map) stops following, [recenter] resumes.
/// Listen to it to show or hide a "Re-center" button.
class FollowCameraController extends ChangeNotifier {
  bool _following = true;
  VanPose? _last;
  Future<void> Function(LatLng)? _move;
  Future<void> Function(LatLng)? _animate;

  bool get following => _following;

  /// Hooks up a real map: [move] jumps the camera (called every frame while
  /// the van animates), [animate] glides it (used by [recenter]).
  void attach({
    required Future<void> Function(LatLng) move,
    required Future<void> Function(LatLng) animate,
  }) {
    _move = move;
    _animate = animate;
  }

  void attachMap(GoogleMapController map) => attach(
        move: (p) => map.moveCamera(CameraUpdate.newLatLng(p)),
        animate: (p) => map.animateCamera(CameraUpdate.newLatLng(p)),
      );

  void detach() {
    _move = null;
    _animate = null;
  }

  /// The van is now drawn at [pose]; follows it when following.
  void onPose(VanPose pose) {
    _last = pose;
    if (_following) _run(_move, pose.position);
  }

  /// The user touched the map: stop following.
  void userMoved() {
    if (!_following) return;
    _following = false;
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

  void _run(Future<void> Function(LatLng)? action, LatLng to) {
    // A map that is being torn down can refuse; the next frame tries again.
    action?.call(to).catchError((Object e) {
      debugPrint('[FollowCamera] camera move failed: $e');
    });
  }
}
