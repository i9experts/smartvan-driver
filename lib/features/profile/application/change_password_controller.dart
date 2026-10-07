import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';

part 'change_password_controller.g.dart';

/// Changes the password. State is the status of the last attempt.
@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  FutureOr<void> build() {}

  /// Returns true when the password was changed.
  Future<bool> change({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(authRepositoryProvider)
        .changePassword(oldPassword: oldPassword, newPassword: newPassword));
    return !state.hasError;
  }
}
