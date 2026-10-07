import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../trip/application/trip_tracking.dart';
import '../data/safety_repository.dart';

part 'sos_controller.g.dart';

/// How an SOS attempt ended.
sealed class SosOutcome {
  const SosOutcome();
}

/// The school has the location; [parentsNotified] parents were told.
class SosSent extends SosOutcome {
  const SosSent(this.parentsNotified);
  final int parentsNotified;
}

/// No GPS fix — nothing was sent.
class SosNoLocation extends SosOutcome {
  const SosNoLocation();
}

/// An SOS was sent a moment ago (429); counts as sent. [error] has the
/// server's message.
class SosRateLimited extends SosOutcome {
  const SosRateLimited(this.error);
  final Object error;
}

/// The SOS did not go through.
class SosFailed extends SosOutcome {
  const SosFailed(this.error);
  final Object error;
}

/// Sends the driver's emergency alert. State is true while one is in flight.
@riverpod
class SosController extends _$SosController {
  @override
  bool build() => false;

  Future<SosOutcome> send() async {
    if (state) return const SosFailed('already sending');
    state = true;
    try {
      final tripId = ref.read(tripTrackingProvider).tripId;
      final position = await ref.read(tripTrackingProvider.notifier).currentPosition();
      if (position == null) return const SosNoLocation();
      final parents = await ref
          .read(safetyRepositoryProvider)
          .sendSos(tripId: tripId, position: position);
      return SosSent(parents);
    } on ApiError catch (e) {
      return e.code == 'SOS_RATE_LIMITED' ? SosRateLimited(e) : SosFailed(e);
    } catch (e) {
      return SosFailed(e);
    } finally {
      state = false;
    }
  }
}
