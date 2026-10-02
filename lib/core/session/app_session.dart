import 'package:flutter/foundation.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';

/// Single place for "the driver is no longer signed in" — used by the
/// logout buttons and by the API layer when the server answers 401.
class AppSession {
  AppSession._();

  static bool _signingOut = false;

  static Future<void> signOut({String reason = 'logout'}) async {
    if (_signingOut) return;
    _signingOut = true;
    try {
      debugPrint('[AppSession] signing out ($reason)');
      await TokenStorage.clear();
      appRouter.go('/login');
    } finally {
      _signingOut = false;
    }
  }
}
