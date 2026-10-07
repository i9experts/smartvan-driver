import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/kid_trip_status.dart';
import '../data/models/passenger.dart';

part 'passengers_state.freezed.dart';

/// The kids of the running trip and what is happening to them.
@freezed
abstract class PassengersState with _$PassengersState {
  const PassengersState._();

  const factory PassengersState({
    /// Riders first; absent and no-show kids at the bottom.
    @Default(<Passenger>[]) List<Passenger> passengers,

    /// Pick/drop saved on the phone but not yet on the server (kidId → state).
    @Default(<String, KidTripStatus>{}) Map<String, KidTripStatus> pending,

    /// Kids with a pick/drop in flight.
    @Default(<String>{}) Set<String> busy,

    /// Kids with an "at stop" / "no-show" call in flight.
    @Default(<String>{}) Set<String> stopBusy,

    /// The last reload failed; the earlier list is still shown.
    @Default(false) bool loadFailed,
  }) = _PassengersState;

  /// Pick state for the UI: a queued action wins over what the server said.
  KidTripStatus statusOf(Passenger p) => pending[p.id] ?? p.tripStatus;

  bool isUnsynced(Passenger p) => pending.containsKey(p.id);

  int get total => passengers.length;

  int get pickedCount => passengers.where((p) {
        final s = statusOf(p);
        return s == KidTripStatus.picked || s == KidTripStatus.dropped;
      }).length;
}
