import 'dart:async';
import 'package:flutter/foundation.dart';
import 'tracked_point.dart';
import 'tracking_uploader.dart';

/// Runs one trip's tracking: takes the GPS [positions], hands every point to
/// the [PointSink] (the uploader), repeats the last position while the van
/// stands still, and reports every point (real or repeated) to [onFix].
///
/// It is the same code whether it runs in the Android background service
/// (the app may be gone) or in the app itself (iOS).
class TrackingEngine {
  TrackingEngine({
    required Stream<TrackedPoint> positions,
    required PointSink sink,
    DateTime Function()? clock,
    this.seed,
    this.onFix,
    this.heartbeatEvery = const Duration(seconds: 5),
    this.quietFor = const Duration(seconds: 4),
  })  : _positions = positions,
        _sink = sink,
        _clock = clock ?? DateTime.now;

  final Stream<TrackedPoint> _positions;
  final PointSink _sink;
  final DateTime Function() _clock;

  /// One-shot read of where the van is, for a van that is standing still when
  /// tracking starts (the GPS stream stays silent without movement).
  final Future<TrackedPoint?> Function()? seed;

  final void Function(TrackedPoint point)? onFix;
  final Duration heartbeatEvery;

  /// No real fix for this long: send a heartbeat. A little under
  /// [heartbeatEvery], so timer jitter never skips a beat.
  final Duration quietFor;

  StreamSubscription<TrackedPoint>? _sub;
  Timer? _timer;
  TrackedPoint? _last;
  DateTime? _lastFixAt;
  Future<void> _chain = Future.value();
  bool _running = false;

  bool get running => _running;

  /// The last real reading, if any.
  TrackedPoint? get lastFix => _last;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    _sub = _positions.listen(
      _onPoint,
      onError: (Object e) => debugPrint('[Tracking] position stream error: $e'),
    );
    _timer = Timer.periodic(heartbeatEvery, (_) => _beat());
    final read = seed;
    if (read != null) {
      try {
        final first = await read();
        if (_running && first != null && _last == null) _onPoint(first);
      } catch (e) {
        debugPrint('[Tracking] first position unavailable: $e');
      }
    }
    // Points left over from an earlier run.
    _enqueue(_sink.flush);
  }

  /// Stops, then tries once more to upload what is buffered.
  Future<void> stop() async {
    if (!_running) return;
    _running = false;
    _timer?.cancel();
    _timer = null;
    // Not awaited: some streams only finish cancelling when the event loop
    // turns, and nothing here depends on it.
    unawaited(_sub?.cancel());
    _sub = null;
    await _chain;
    await _sink.flush();
  }

  void _onPoint(TrackedPoint point) {
    if (!_running) return;
    _last = point;
    _lastFixAt = _clock();
    _enqueue(() => _sink.submit(point));
    onFix?.call(point);
  }

  void _beat() {
    final last = _last;
    final at = _lastFixAt;
    if (!_running || last == null || at == null) return;
    if (_clock().difference(at) < quietFor) return;
    final beat = last.heartbeat(_clock());
    _enqueue(() => _sink.submit(beat, force: true));
    onFix?.call(beat);
  }

  /// One upload at a time, in order.
  void _enqueue(Future<void> Function() job) {
    _chain = _chain.then((_) => job()).catchError((Object e) {
      debugPrint('[Tracking] upload failed: $e');
    });
  }
}
