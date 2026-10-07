import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/network_providers.dart';

/// `/auth/*` calls. Storing the token and navigating are the caller's job.
class AuthRepository {
  const AuthRepository(this._api);

  final ApiClient _api;

  /// `POST /auth/login`. Returns the JWT. Wrong credentials surface as
  /// `UnauthorizedException` / `ApiError` with the server's message.
  Future<String> login({
    required String loginId,
    required String password,
  }) async {
    final token = await _api.postEnvelope(
      '/auth/login',
      (e) {
        final data = e['data'];
        final nested = data is Map ? data['token'] : null;
        return (nested ?? e['token'] ?? '').toString();
      },
      body: {
        'loginId': loginId.trim(),
        'password': password,
        'userType': 'driver',
      },
    );
    if (token.isEmpty) {
      throw const ApiError(
        code: 'NO_TOKEN',
        message: 'Login failed. Please try again.',
        status: 200,
      );
    }
    return token;
  }

  /// `POST /auth/change-password`.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) =>
      _api.post<void>(
        '/auth/change-password',
        (_) {},
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'userType': 'driver',
        },
      );

  /// Registers this phone's push token (`POST /van/update-profile`).
  Future<void> registerFcmToken(String fcmToken) => _api.post<void>(
        '/van/update-profile',
        (_) {},
        body: {'fcmToken': fcmToken, 'userType': 'driver'},
      );
}

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.watch(apiClientProvider)));
