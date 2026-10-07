import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/token_store.dart';
import '../data/auth_repository.dart';
import 'session_providers.dart';

part 'login_controller.g.dart';

/// Sign-in. State is the status of the last attempt: loading while the
/// request runs, an error to show, or data (null) on success.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  /// Returns true when the driver is signed in.
  Future<bool> signIn({
    required String loginId,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await ref
          .read(authRepositoryProvider)
          .login(loginId: loginId, password: password);
      await ref.read(tokenStorageProvider).save(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTypeKey, 'driver');
      // The push token may have been fetched before anyone was signed in;
      // attach it to this account now. Never blocks or fails the login.
      unawaited(ref.read(pushRegistrarProvider)().catchError((Object _) {}));
    });
    return !state.hasError;
  }
}
