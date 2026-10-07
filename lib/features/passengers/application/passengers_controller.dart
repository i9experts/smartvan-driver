import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/sync_queue.dart';
import '../../chat/data/chat_repository.dart';
import '../../chat/data/models/conversation.dart';
import '../../trip/application/kid_absence_events.dart';
import '../../trip/application/trip_tracking.dart';
import '../../trip/data/models/geo_point.dart';
import '../data/models/passenger.dart';
import '../data/passengers_repository.dart';
import 'passengers_state.dart';

part 'passengers_controller.g.dart';

/// How a pick / drop ended up.
enum StopActionOutcome {
  /// The server has it.
  sent,

  /// Saved on the phone; it will sync automatically.
  queued,

  /// A drop needs GPS and none was available — nothing was done.
  noGps,
}

/// The kids of trip [tripId]: loading, counting, pick/drop (through the
/// offline queue), "at stop" and "no-show". One copy shared by the trip and
/// passengers screens.
@riverpod
class PassengersController extends _$PassengersController {
  @override
  Future<PassengersState> build(String tripId) async {
    // Queued pick/drops reached the server, or a parent changed an absence:
    // reload what the server now says.
    ref.listen(syncQueueSyncedProvider, (_, __) => refresh());
    ref.listen(kidAbsenceEventsProvider, (_, __) => refresh());
    return _fetch();
  }

  Future<PassengersState> _fetch() async {
    final repo = ref.read(passengersRepositoryProvider);
    final list = await repo.activePassengers();
    final current = state.valueOrNull;
    return PassengersState(
      passengers: _sorted(list),
      pending: repo.pendingStatuses(tripId),
      busy: current?.busy ?? const {},
      stopBusy: current?.stopBusy ?? const {},
    );
  }

  /// Riders first; absent and no-show kids at the bottom (stable).
  List<Passenger> _sorted(List<Passenger> list) {
    int rank(Passenger p) => (p.absent || p.noShow) ? 1 : 0;
    final indexed = list.asMap().entries.toList()
      ..sort((a, b) {
        final r = rank(a.value).compareTo(rank(b.value));
        return r != 0 ? r : a.key.compareTo(b.key);
      });
    return indexed.map((e) => e.value).toList();
  }

  /// Reloads quietly. If it fails the earlier list stays (so picks and drops
  /// still work offline); only a first load that fails is an error.
  Future<void> refresh() async {
    final previous = state.valueOrNull;
    try {
      state = AsyncData(await _fetch());
    } catch (e, st) {
      if (previous == null) {
        state = AsyncError(e, st);
      } else {
        state = AsyncData(previous.copyWith(
          loadFailed: true,
          pending: ref.read(passengersRepositoryProvider).pendingStatuses(tripId),
        ));
      }
    }
  }

  PassengersState get _current => state.requireValue;

  void _update(PassengersState Function(PassengersState s) change) {
    final s = state.valueOrNull;
    if (s != null) state = AsyncData(change(s));
  }

  String _tripOf(Passenger kid) => kid.tripId ?? tripId;

  /// Picks [kid] up (through the offline queue). Throws the `AppException`
  /// when the server rejects it.
  Future<StopActionOutcome> pick(Passenger kid) async {
    if (kid.id.isEmpty || _current.busy.contains(kid.id)) {
      return StopActionOutcome.queued;
    }
    _update((s) => s.copyWith(busy: {...s.busy, kid.id}));
    try {
      final outcome = await ref
          .read(passengersRepositoryProvider)
          .pick(tripId: _tripOf(kid), kidId: kid.id);
      return await _afterQueue(outcome);
    } finally {
      _update((s) => s.copyWith(busy: {...s.busy}..remove(kid.id)));
    }
  }

  /// Drops [kid] at home (needs GPS: the position is sent with the drop).
  Future<StopActionOutcome> drop(Passenger kid) async {
    if (kid.id.isEmpty || _current.busy.contains(kid.id)) {
      return StopActionOutcome.queued;
    }
    _update((s) => s.copyWith(busy: {...s.busy, kid.id}));
    try {
      // Real GPS only: never a made-up coordinate in the trip's history.
      final GeoPoint? position =
          await ref.read(tripTrackingProvider.notifier).currentPosition();
      if (position == null) return StopActionOutcome.noGps;
      final outcome = await ref.read(passengersRepositoryProvider).drop(
            tripId: _tripOf(kid),
            kidId: kid.id,
            position: position,
          );
      return await _afterQueue(outcome);
    } finally {
      _update((s) => s.copyWith(busy: {...s.busy}..remove(kid.id)));
    }
  }

  Future<StopActionOutcome> _afterQueue(SubmitOutcome outcome) async {
    if (outcome == SubmitOutcome.sent) {
      await refresh();
      return StopActionOutcome.sent;
    }
    // Saved offline: show the new state from the queue right away.
    _update((s) => s.copyWith(
        pending: ref.read(passengersRepositoryProvider).pendingStatuses(tripId)));
    return StopActionOutcome.queued;
  }

  /// "At stop — tell parent". Starts the waiting timer on the kid's card.
  Future<void> arrivedAtStop(Passenger kid) async {
    if (kid.id.isEmpty || _current.stopBusy.contains(kid.id)) return;
    _update((s) => s.copyWith(stopBusy: {...s.stopBusy, kid.id}));
    try {
      final arrived = await ref
          .read(passengersRepositoryProvider)
          .arrivedAtStop(tripId: _tripOf(kid), kidId: kid.id);
      final at = arrived.waitingSince ?? ref.read(clockProvider)().toUtc();
      _update((s) => s.copyWith(passengers: [
            for (final p in s.passengers)
              p.id == kid.id ? p.copyWith(waitingSince: at) : p
          ]));
    } finally {
      _update((s) => s.copyWith(stopBusy: {...s.stopBusy}..remove(kid.id)));
    }
  }

  /// "Not here — move on" (pick trips): tells the parent the van left.
  Future<void> markNoShow(Passenger kid, {String? note}) async {
    if (kid.id.isEmpty || _current.stopBusy.contains(kid.id)) return;
    _update((s) => s.copyWith(stopBusy: {...s.stopBusy, kid.id}));
    try {
      await ref
          .read(passengersRepositoryProvider)
          .markNoShow(tripId: _tripOf(kid), kidId: kid.id, note: note);
      _update((s) => s.copyWith(
          passengers: _sorted([
        for (final p in s.passengers)
          p.id == kid.id ? p.copyWith(noShow: true) : p
      ])));
    } finally {
      _update((s) => s.copyWith(stopBusy: {...s.stopBusy}..remove(kid.id)));
    }
  }

  /// Opens (or creates) the chat with [kid]'s parent.
  Future<Conversation> messageParent(Passenger kid) =>
      ref.read(chatRepositoryProvider).start(kid.id);
}
