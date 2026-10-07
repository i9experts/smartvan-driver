import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/token_store.dart';
import 'session_providers.dart';

part 'splash_controller.g.dart';

/// Where the splash screen sends the driver.
sealed class SplashDestination {
  const SplashDestination();
}

class GoToLogin extends SplashDestination {
  const GoToLogin();
}

class GoToHome extends SplashDestination {
  const GoToHome();
}

/// The app was killed mid-trip: go straight back to it.
class ResumeTrip extends SplashDestination {
  const ResumeTrip(this.trip);
  final Map<String, dynamic> trip;
}

@riverpod
class SplashController extends _$SplashController {
  @override
  void build() {}

  Future<SplashDestination> decide() async {
    final loggedIn = await ref.read(tokenStorageProvider).hasToken();
    if (!loggedIn) return const GoToLogin();
    final activeTrip = ref.read(resumableTripProvider);
    return activeTrip != null ? ResumeTrip(activeTrip) : const GoToHome();
  }
}
