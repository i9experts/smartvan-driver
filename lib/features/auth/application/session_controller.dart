import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/router_provider.dart';
import '../../../core/storage/token_store.dart';
import '../../profile/application/driver_profile_provider.dart';
import '../../trip/application/trip_tracking.dart';

/// Why the driver is being signed out.
enum SignOutReason {
  /// The driver pressed Logout: pickups/drops still waiting to sync are
  /// discarded.
  logout,

  /// The server answered 401: waiting items are kept and sent after the
  /// driver logs back in.
  sessionExpired,
}

/// The single place for "the driver is no longer signed in" — used by the
/// logout button and by the API layer when the server answers 401.
class SessionController {
  SessionController(this._ref);

  final Ref _ref;
  bool _signingOut = false;

  Future<void> signOut({SignOutReason reason = SignOutReason.logout}) async {
    if (_signingOut) return;
    _signingOut = true;
    try {
      debugPrint('[Session] signing out (${reason.name})');
      // Stop GPS/socket/foreground service — nobody is signed in to own it.
      await _ref.read(tripTrackingProvider.notifier).stop();
      await _ref.read(tokenStorageProvider).clear();
      _ref.invalidate(driverProfileProvider);
      if (reason == SignOutReason.logout) {
        await _ref.read(syncQueueProvider).clear();
      }
      _ref.read(routerProvider).go(AppRoutes.login);
    } finally {
      _signingOut = false;
    }
  }
}

final sessionProvider =
    Provider<SessionController>((ref) => SessionController(ref));
