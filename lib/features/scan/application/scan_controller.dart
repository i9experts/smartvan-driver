import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../trip/application/trip_tracking.dart';
import '../data/scan_repository.dart';
import 'scan_state.dart';

part 'scan_controller.g.dart';

/// Reads QR cards continuously while the scan screen is open: filters
/// repeats, checks there is a trip, flushes the offline queue, scans, and
/// publishes an [ScanOutcome] that clears itself after a few seconds.
@riverpod
class ScanController extends _$ScanController {
  /// How long the same card is ignored after it was read.
  static const repeatWindow = Duration(seconds: 4);

  /// How long an outcome stays on screen.
  static const outcomeDuration = Duration(seconds: 3);

  String? _lastPayload;
  DateTime? _lastAt;
  Timer? _clearTimer;

  @override
  ScanState build() {
    ref.onDispose(() => _clearTimer?.cancel());
    return const ScanState();
  }

  Future<void> onCode(String raw) async {
    if (state.busy) return;

    // Same card still in front of the camera — ignore for a few seconds.
    final now = DateTime.now();
    if (raw == _lastPayload &&
        _lastAt != null &&
        now.difference(_lastAt!) < repeatWindow) {
      return;
    }
    _lastPayload = raw;
    _lastAt = now;

    if (!ScanRepository.looksLikeCard(raw)) {
      _show(const ScanNotACard());
      return;
    }

    final tripId = ref.read(tripTrackingProvider).tripId;
    if (tripId == null) {
      _show(const ScanNoActiveTrip());
      return;
    }

    state = state.copyWith(busy: true);
    try {
      // Any offline picks/drops must reach the server first, otherwise the
      // server could decide pick vs drop from stale state.
      await ref.read(syncQueueProvider).flush();
      final position =
          await ref.read(tripTrackingProvider.notifier).currentPosition();
      final result = await ref.read(scanRepositoryProvider).scan(
            tripId: tripId,
            qrPayload: raw,
            position: position,
          );
      state = state.copyWith(session: [result, ...state.session]);
      _show(ScanSucceeded(result));
    } on NetworkException {
      _show(const ScanOffline());
    } on ApiError catch (e) {
      _show(ScanFailed(e.code, e));
    } on AppException catch (e) {
      _show(ScanFailed(null, e));
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  void _show(ScanOutcome outcome) {
    _clearTimer?.cancel();
    state = state.copyWith(outcome: outcome);
    _clearTimer = Timer(outcomeDuration, () {
      state = state.copyWith(outcome: null);
    });
  }
}
