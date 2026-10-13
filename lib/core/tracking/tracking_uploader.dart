import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/app_exception.dart';
import 'location_buffer.dart';
import 'tracked_point.dart';

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
///
/// All HTTP for tracking goes through here, and only one place (the app or
/// the Android service, never both) owns an instance.
class TrackingUploader {
  TrackingUploader({
    required this.tripId,
    required ApiClient api,
    required LocationBuffer buffer,
    DateTime Function()? clock,
    this.liveInterval = const Duration(seconds: 5),
    this.batchSize = 2000,
    this.onTripOver,
  })  : _api = api,
        _buffer = buffer,
        _clock = clock ?? DateTime.now;

  static const tripNotOngoingCode = 'TRIP_NOT_ONGOING';

  final String tripId;
  final ApiClient _api;
  final LocationBuffer _buffer;
  final DateTime Function() _clock;
  final Duration liveInterval;
  final int batchSize;

  /// The server says this trip is not ongoing (ended in the admin panel or on
  /// another phone): the caller stops tracking.
  final VoidCallback? onTripOver;

  bool _offline = false;
  bool _flushing = false;
  DateTime? _lastPost;

  bool get offline => _offline;

  /// Hands over a point. [force] posts it even if one went a moment ago (the
  /// stand-still heartbeat, which has its own 5 s rhythm).
  Future<void> submit(TrackedPoint point, {bool force = false}) async {
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
      case _Outcome.tripOver:
        break;
      case _Outcome.retryLater:
        _offline = true;
        await _buffer.add(tripId, point);
    }
  }

  /// Uploads what is buffered, oldest first. Safe to call any time (also when
  /// the connection is reported back); stops at the first failure and keeps
  /// the rest.
  Future<void> flush() async {
    if (_flushing) return;
    _flushing = true;
    try {
      while (true) {
        final batch = await _buffer.next(tripId, batchSize);
        if (batch.isEmpty) return;
        try {
          await _api.post<void>(
            '/trips/$tripId/locations/batch',
            (_) {},
            body: {
              'points': [for (final b in batch) b.point.toBatchJson()],
            },
          );
        } on AppException catch (e) {
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

  Future<_Outcome> _post(TrackedPoint p) async {
    try {
      await _api.post<void>(
        '/trips/updateLocation/$tripId',
        (_) {},
        body: {
          'lat': p.lat,
          'lng': p.lng,
          if (p.speed != null && p.speed! >= 0) 'speed': p.speed,
        },
      );
      return _Outcome.sent;
    } on AppException catch (e) {
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

enum _Outcome { sent, tripOver, retryLater }
