import 'package:flutter/foundation.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';
import '../sync/sync_queue.dart';

/// Single place for "the driver is no longer signed in" — used by the
/// logout buttons and by the API layer when the server answers 401.
class AppSession {
  AppSession._();

  static bool _signingOut = false;

  /// Text for the logout confirmation dialog — warns if pickups/drops are
  /// still waiting to sync, because a manual logout discards them.
  static String logoutConfirmText() {
    final n = SyncQueue.instance.pending.value;
    if (n == 0) return 'Are you sure you want to logout?';
    return '$n pickup/drop update${n == 1 ? '' : 's'} not synced yet. '
        'Logging out now will discard ${n == 1 ? 'it' : 'them'}. '
        'Connect to the internet first if possible.';
  }

  /// [reason] 'logout' = the driver pressed Logout (pending offline items
  /// are discarded). '401' = session expired (items are kept and sent after
  /// the driver logs back in).
  static Future<void> signOut({String reason = 'logout'}) async {
    if (_signingOut) return;
    _signingOut = true;
    try {
      debugPrint('[AppSession] signing out ($reason)');
      await TokenStorage.clear();
      if (reason == 'logout') await SyncQueue.instance.clear();
      appRouter.go('/login');
    } finally {
      _signingOut = false;
    }
  }
}
