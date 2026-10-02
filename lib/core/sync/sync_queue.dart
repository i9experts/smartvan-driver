import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_errors.dart';
import '../network/api_service.dart';

/// What kind of driver action a queued request represents.
class SyncKind {
  static const pick = 'pick';
  static const drop = 'drop';
  static const location = 'location';
}

enum SubmitOutcome {
  /// Reached the server and succeeded.
  sent,

  /// Saved on the device; will be sent automatically when back online.
  queued,
}

/// Offline-first queue for the requests a driver makes during a trip.
///
/// Rules:
/// - Requests are replayed strictly in the order they were made (a pick is
///   always sent before the drop of the same kid).
/// - While anything is waiting, new requests join the back of the queue
///   instead of jumping ahead of it.
/// - Network errors and 5xx keep the item for later; other 4xx answers mean
///   the server rejected it, so it is removed (and logged) to avoid
///   blocking the queue forever.
/// - Location points are coalesced: only the latest one per trip is kept,
///   and points older than [_staleLocation] are dropped, because replaying
///   old GPS points would fire stale geofence alerts to parents.
class SyncQueue {
  SyncQueue._();
  static final SyncQueue instance = SyncQueue._();

  static const _boxName = 'sync_queue';
  static const _staleLocation = Duration(minutes: 3);

  late Box _box;
  bool _ready = false;
  bool _flushing = false;
  Timer? _retryTimer;
  StreamSubscription? _connectivitySub;

  /// Number of items waiting to be sent. Listen to update badges in the UI.
  final ValueNotifier<int> pending = ValueNotifier<int>(0);

  /// Emits after a flush sends at least one item, so screens can reload
  /// server state.
  final StreamController<void> _synced = StreamController<void>.broadcast();
  Stream<void> get onSynced => _synced.stream;

  Future<void> init() async {
    if (_ready) return;
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    _ready = true;
    _refreshCount();

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) flush();
    });
    _retryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (pending.value > 0) flush();
    });
    if (pending.value > 0) unawaited(flush());
  }

  /// Sends [body] to [path] now if possible, otherwise queues it.
  ///
  /// Throws only when the server actively rejects the request (4xx other
  /// than 401) and nothing was queued — the caller should show that error.
  Future<SubmitOutcome> submit({
    required String kind,
    required String path,
    required Map<String, dynamic> body,
    String? tripId,
    String? kidId,
  }) async {
    if (kind == SyncKind.location) {
      if (pending.value > 0) {
        await _enqueue(kind, path, body, tripId, kidId);
        return SubmitOutcome.queued;
      }
    } else if (pending.value > 0) {
      // Keep ordering: never let a new pick/drop overtake an older one.
      await _enqueue(kind, path, body, tripId, kidId);
      unawaited(flush());
      return SubmitOutcome.queued;
    }

    try {
      await ApiService.post(path, body);
      // A fresher point just landed — an older queued one must never be
      // replayed after it.
      if (kind == SyncKind.location) await _dropQueuedLocations(tripId);
      return SubmitOutcome.sent;
    } catch (e) {
      if (ApiErrors.isNetworkError(e) || ApiErrors.isServerError(e)) {
        await _enqueue(kind, path, body, tripId, kidId);
        return SubmitOutcome.queued;
      }
      rethrow;
    }
  }

  /// Tries to send everything. Returns true if the queue is empty afterwards.
  Future<bool> flush() async {
    if (!_ready) return true;
    if (_flushing) return pending.value == 0;
    _flushing = true;
    var sentAny = false;
    try {
      final keys = _box.keys.toList()..sort((a, b) => (a as int).compareTo(b as int));
      for (final key in keys) {
        final raw = _box.get(key);
        if (raw is! Map) {
          await _box.delete(key);
          continue;
        }
        final item = Map<String, dynamic>.from(raw);
        final createdAt = DateTime.tryParse(item['createdAt']?.toString() ?? '');

        if (item['kind'] == SyncKind.location &&
            createdAt != null &&
            DateTime.now().difference(createdAt) > _staleLocation) {
          await _box.delete(key);
          continue;
        }

        try {
          await ApiService.post(
            item['path'] as String,
            Map<String, dynamic>.from(item['body'] as Map),
          );
          await _box.delete(key);
          sentAny = true;
        } catch (e) {
          if (ApiErrors.isNetworkError(e) || ApiErrors.isServerError(e)) {
            break; // still offline / server down — try again later
          }
          final status = e is DioException ? e.response?.statusCode : null;
          if (status == 401) break; // session expired; keep for after re-login
          debugPrint('[SyncQueue] server rejected ${item['kind']} ${item['path']} '
              '($status): ${ApiErrors.message(e)} — dropping it');
          await _box.delete(key);
        }
      }
    } finally {
      _flushing = false;
      _refreshCount();
      if (sentAny) _synced.add(null);
    }
    return pending.value == 0;
  }

  /// Kid statuses that are saved on the device but not yet on the server,
  /// so lists can show them immediately. kidId -> 'picked' | 'dropped'.
  Map<String, String> pendingKidStatuses(String? tripId) {
    final result = <String, String>{};
    if (!_ready) return result;
    final keys = _box.keys.toList()..sort((a, b) => (a as int).compareTo(b as int));
    for (final key in keys) {
      final raw = _box.get(key);
      if (raw is! Map) continue;
      final kidId = raw['kidId']?.toString();
      if (kidId == null) continue;
      if (tripId != null && raw['tripId']?.toString() != tripId) continue;
      if (raw['kind'] == SyncKind.pick) result[kidId] = 'picked';
      if (raw['kind'] == SyncKind.drop) result[kidId] = 'dropped';
    }
    return result;
  }

  /// Removes everything (used on manual logout).
  Future<void> clear() async {
    if (!_ready) return;
    await _box.clear();
    _refreshCount();
  }

  Future<void> _enqueue(String kind, String path, Map<String, dynamic> body,
      String? tripId, String? kidId) async {
    if (kind == SyncKind.location) await _dropQueuedLocations(tripId);
    await _box.add({
      'kind': kind,
      'path': path,
      'body': body,
      'tripId': tripId,
      'kidId': kidId,
      'createdAt': DateTime.now().toIso8601String(),
    });
    _refreshCount();
  }

  Future<void> _dropQueuedLocations(String? tripId) async {
    final old = _box.keys.where((k) {
      final v = _box.get(k);
      return v is Map && v['kind'] == SyncKind.location && v['tripId']?.toString() == tripId;
    }).toList();
    if (old.isNotEmpty) await _box.deleteAll(old);
  }

  void _refreshCount() {
    // Location points are background noise — only count driver actions.
    pending.value = _box.values
        .where((v) => v is Map && v['kind'] != SyncKind.location)
        .length;
  }

  @visibleForTesting
  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _connectivitySub?.cancel();
  }
}
