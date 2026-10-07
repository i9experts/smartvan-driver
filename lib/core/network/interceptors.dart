import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/token_store.dart';
import 'app_exception.dart';

/// Attaches the Bearer token per request (not on `Dio.options`) so a logout
/// can never leave the previous driver's token on the client.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final TokenStore _tokens;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokens.read();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }
}

/// Request/response log lines (debug console only).
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[API] -> ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint('[API] <- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        '[API] !! ERROR ${err.response?.statusCode} ${err.requestOptions.path} — ${err.response?.data}');
    handler.next(err);
  }
}

/// Turns every failure into an [AppException] (carried in
/// `DioException.error`; the response stays attached) and reports 401s.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({
    required this.onUnauthorized,
    this.unauthorizedExemptPaths = const ['/auth/login'],
  });

  /// Called when the server answers 401 (session expired / revoked).
  final Future<void> Function() onUnauthorized;

  /// A wrong password answers 401 on login; that must show an error on the
  /// login screen, not sign the driver out.
  final List<String> unauthorizedExemptPaths;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final exception = AppException.fromDio(err);
    if (exception is UnauthorizedException &&
        !unauthorizedExemptPaths
            .any((p) => err.requestOptions.path.contains(p))) {
      debugPrint('[API] 401 received — signing out');
      await onUnauthorized();
    }
    handler.next(err.copyWith(error: exception));
  }
}
