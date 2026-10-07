import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/alerts_repository.dart';

part 'send_alert_controller.g.dart';

/// Sends a message to the school admin. State is the status of the last send.
@riverpod
class SendAlertController extends _$SendAlertController {
  @override
  FutureOr<void> build() {}

  /// Returns true when the alert was sent.
  Future<bool> send(String message) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(alertsRepositoryProvider).sendAlert(message));
    return !state.hasError;
  }
}
