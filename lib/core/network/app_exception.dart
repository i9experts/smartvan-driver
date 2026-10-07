import 'dart:io';
import 'package:dio/dio.dart';

/// Every failure that leaves the data layer is one of these. The Dio error
/// interceptor produces them, repositories let them through, controllers and
/// screens show [userMessage].
sealed class AppException implements Exception {
  const AppException();

  /// Converts anything thrown by Dio / dart:io into an [AppException].
  factory AppException.from(Object error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final inner = error.error;
      if (inner is AppException) return inner;
      return AppException.fromDio(error);
    }
    if (error is SocketException) return const NetworkException();
    return UnknownException(error);
  }

  factory AppException.fromDio(DioException e) {
    if (_isNetworkFailure(e)) return const NetworkException();

    final status = e.response?.statusCode;
    final body = e.response?.data;
    final message = _messageOf(body);

    if (status == 401) return UnauthorizedException(message);
    if (status != null && status >= 500) {
      return ServerException(message, status);
    }
    if (status != null) {
      return ApiError(
        code: body is Map && body['code'] is String
            ? body['code'] as String
            : null,
        message: message,
        status: status,
        data: body,
      );
    }
    return UnknownException(e);
  }

  /// The one place that decides what the user reads for a failure.
  String get userMessage;

  /// Request never reached the server (no internet, DNS, timeout).
  static bool _isNetworkFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.unknown:
        return e.error is SocketException || e.response == null;
      default:
        return false;
    }
  }

  /// Backend sends `message` (String or List) or `error`.
  static String? _messageOf(Object? body) {
    if (body is! Map) return null;
    final msg = body['message'] ?? body['error'];
    if (msg is String && msg.trim().isNotEmpty) return msg;
    if (msg is List && msg.isNotEmpty) return msg.first.toString();
    return null;
  }
}

/// No internet / timeout.
class NetworkException extends AppException {
  const NetworkException();

  @override
  String get userMessage =>
      'No internet connection. Please check your network and try again.';

  @override
  String toString() => 'NetworkException';
}

/// 401 — the token is missing, expired or revoked.
class UnauthorizedException extends AppException {
  const UnauthorizedException([this.serverMessage]);

  final String? serverMessage;

  @override
  String get userMessage =>
      serverMessage ?? 'Your session has expired. Please log in again.';

  @override
  String toString() => 'UnauthorizedException($serverMessage)';
}

/// 5xx.
class ServerException extends AppException {
  const ServerException([this.serverMessage, this.status]);

  final String? serverMessage;
  final int? status;

  @override
  String get userMessage =>
      serverMessage ??
      'Server is having trouble right now. Please try again shortly.';

  @override
  String toString() => 'ServerException($status, $serverMessage)';
}

/// The server answered with a 4xx. [code] carries the backend's machine
/// readable code (`KIDS_NOT_DROPPED`, `CHECKLIST_REQUIRED`, `INVALID_QR`, ...);
/// [data] is the raw error body for the few endpoints that put extra
/// payload in it (e.g. the kids list of `KIDS_NOT_DROPPED`).
class ApiError extends AppException {
  const ApiError({this.code, this.message, required this.status, this.data});

  final String? code;
  final String? message;
  final int status;
  final Object? data;

  @override
  String get userMessage =>
      message ?? 'Something went wrong. Please try again.';

  @override
  String toString() => 'ApiError($status, $code, $message)';
}

/// Anything else (parsing errors, bugs, cancelled requests).
class UnknownException extends AppException {
  const UnknownException([this.cause]);

  final Object? cause;

  @override
  String get userMessage => 'Something went wrong. Please try again.';

  @override
  String toString() => 'UnknownException($cause)';
}
