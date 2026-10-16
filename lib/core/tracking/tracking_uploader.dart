import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/app_exception.dart';
import 'location_buffer.dart';
import 'tracked_point.dart';
import 'tracking_session.dart';

/// Where the engine hands its points.
abstract interface class PointSink {
  Future<void> submit(TrackedPoint point, {bool force = false});
  Future<void> flush();
}

/// Gets the van's points to the server, with the one `POST
/// /trips/:id/updateLocation` for live tracking and the offline buffer.
///
/// - Online: at most one live POST every [liveInterval] (the newest point
///   wins, the ones in between are not needed).
/// - A POST that cannot reach the server puts the van "offline": from then on
///   *every* point is buffered (lat, lng, time, speed), and one POST per
///   [liveInterval] probes for the connection.
/// - When a POST gets through again, the buffer is uploaded oldest first, at
///   most [batchSize] points per `POST /trips/:id/locations/batch`; a batch
///   is deleted locally only after the server accepted it.
/// - With a [session] the trip is claimed first (POST
///   /trips/:id/tracking-session); every point then carries its ids. A 409
///   `TRACKING_SESSION_REPLACED` means another phone took the trip over: the
///   point is not buffered and [onSessionReplaced] is called, once.
///
/// All HTTP for tracking goes through here, and only one place (the app or
/// the Android service, never both) owns an instance.
class TrackingUploader implements PointSink {
  TrackingUploader({
    required this.tripId,
    required ApiClient api,
    required LocationBuffer buffer,
    DateTime Function()? clock,
    this.liveInterval = const Duration(seconds: 5),
    this.batchSize = 2000,
    this.onTripOver,
    TrackingSession? session,
    this.onSessionClaimed,
    this.onSessionReplaced,
  })  : _api = api,
        _buffer = buffer,
        _session = session,
        _clock = clock ?? DateTime.now;

  static const tripNotOngoingCode = 'TRIP_NOT_ONGOING';
  static const sessionReplacedCode = 'TRACKING_SESSION_REPLACED';

  final String tripId;
  final ApiClient _api;
  final LocationBuffer _buffer;
  final DateTime Function() _clock;
  final Duration liveInterval;
  final int batchSize;

  /// The server says this trip is not ongoing (ended in the admin panel or on
  /// another phone): the caller stops tracking.
  final VoidCallback? onTripOver;

  /// The server accepted this phone's session (the caller remembers it, so a
  /// restarted service does not claim again and steal the trip back).
  final VoidCallback? onSessionClaimed;

  /// Another phone took the trip over: the caller stops tracking.
  final VoidCallback? onSessionReplaced;

  TrackingSession? _session;
  bool _replaced = false;
  bool _offline = false;
  bool _flushing = false;
  DateTime? _lastPost;

  bool get offline => _offline;

  /// Hands over a point. [force] posts it even if one went a moment ago (the
  /// stand-still heartbeat, which has its own 5 s rhythm).
  @override
  Future<void> submit(TrackedPoint point, {bool force = false}) async {
    if (_replaced) return;
    final now = _clock();
    final due = force ||
        _lastPost == null ||
        now.difference(_lastPost!) >= liveInterval;

    if (_offline) {
      final key = await _buffer.add(tripId, point);
      if (!due) return;
      _lastPost = now;
      if (await _post(point) == _Outcome.sent) {
        // It got through live: it must not go again with the batch.
        await _buffer.remove([key]);
        _offline = false;
        await flush();
      }
      return;
    }

    if (!due) return;
    _lastPost = now;
    switch (await _post(point)) {
      case _Outcome.sent:
        if (await _buffer.count(tripId) > 0) await flush();
      case _Outcome.tripOver || _Outcome.replaced:
        break;
      case _Outcome.retryLater:
        _offline = true;
        await _buffer.add(tripId, point);
    }
  }

  /// Uploads what is buffered, oldest first. Safe to call any time (also when
  /// the connection is reported back); stops at the first failure and keeps
  /// the rest.
  @override
  Future<void> flush() async {
    if (_flushing || _replaced) return;
    _flushing = true;
    try {
      while (true) {
        final batch = await _buffer.next(tripId, batchSize);
        if (batch.isEmpty) return;
        // Not claimed yet: sending its ids now could look like a stranger.
        final claim = await _ensureClaimed();
        if (claim == _Outcome.retryLater) {
          _offline = true;
          return;
        }
        if (claim != null) return;
        try {
          await _api.post<void>(
            '/trips/$tripId/locations/batch',
            (_) {},
            body: {
              ...?_session?.fields,
              'points': [for (final b in batch) b.point.toBatchJson()],
            },
          );
        } on AppException catch (e) {
          if (e is ApiError && e.code == sessionReplacedCode) {
            // Whatever this phone still holds belongs to a trip it lost.
            await _buffer.remove(batch.map((b) => b.key));
            _markReplaced();
            return;
          }
          if (_retryable(e)) {
            _offline = true;
            return;
          }
          // The server will never take these (trip too old, bad data): do
          // not keep them for ever.
          debugPrint('[Tracking] batch refused, dropping ${batch.length}: $e');
          if (e is ApiError && e.code == tripNotOngoingCode) onTripOver?.call();
        }
        await _buffer.remove(batch.map((b) => b.key));
        _offline = false;
      }
    } finally {
      _flushing = false;
    }
  }

  void _markReplaced() {
    if (_replaced) return;
    _replaced = true;
    onSessionReplaced?.call();
  }

  /// Claims the trip for this phone's session, once. Null = nothing more to
  /// do (claimed, or no session); otherwise the outcome the caller returns.
  Future<_Outcome?> _ensureClaimed() async {
    final session = _session;
    if (session == null || session.claimed) return null;
    try {
      await _api.post<void>(
        '/trips/$tripId/tracking-session',
        (_) {},
        body: session.fields,
      );
      _session = session.asClaimed;
      onSessionClaimed?.call();
      return null;
    } on AppException catch (e) {
      if (e is ApiError && e.code == tripNotOngoingCode) {
        onTripOver?.call();
        return _Outcome.tripOver;
      }
      if (_retryable(e)) return _Outcome.retryLater;
      // The server will not take a session: track the old way, ids left out.
      debugPrint('[Tracking] session refused, tracking without one: $e');
      _session = null;
      return null;
    }
  }

  /// No `time` on live points: the server stamps them on arrival, so a phone
  /// whose clock is off cannot get its live points dropped as "future".
  Future<_Outcome> _post(TrackedPoint p) async {
    final claim = await _ensureClaimed();
    if (claim != null) return claim;
    try {
      await _api.post<void>(
        '/trips/updateLocation/$tripId',
        (_) {},
        body: {
          'lat': p.lat,
          'lng': p.lng,
          if (p.speed != null && p.speed! >= 0) 'speed': p.speed,
          if (p.accuracy != null && p.accuracy! >= 0) 'accuracy': p.accuracy,
          ...?_session?.fields,
        },
      );
      return _Outcome.sent;
    } on AppException catch (e) {
      if (e is ApiError && e.code == sessionReplacedCode) {
        _markReplaced();
        return _Outcome.replaced;
      }
      if (e is ApiError && e.code == tripNotOngoingCode) {
        onTripOver?.call();
        return _Outcome.tripOver;
      }
      if (_retryable(e)) return _Outcome.retryLater;
      // The server refused this point for good; carry on with the next.
      debugPrint('[Tracking] point refused: $e');
      return _Outcome.sent;
    }
  }

  /// No connection, a server error, or a login that has to come back: keep
  /// the points and try again.
  bool _retryable(AppException e) =>
      e is NetworkException ||
      e is ServerException ||
      e is UnauthorizedException ||
      e is UnknownException;
}

enum _Outcome { sent, tripOver, replaced, retryLater }
