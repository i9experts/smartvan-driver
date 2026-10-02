import 'dart:io';
import 'package:dio/dio.dart';

/// Turns exceptions into something a driver can actually read, instead of
/// dumping `DioException [bad response]: ...` into a SnackBar.
class ApiErrors {
  ApiErrors._();

  /// True when the request never reached the server (no internet, DNS,
  /// timeout). These are the cases worth retrying from the offline queue.
  static bool isNetworkError(Object error) {
    if (error is SocketException) return true;
    if (error is! DioException) return false;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.unknown:
        return error.error is SocketException || error.response == null;
      default:
        return false;
    }
  }

  /// Server answered, but with a 5xx — also worth retrying later.
  static bool isServerError(Object error) {
    final code = error is DioException ? error.response?.statusCode : null;
    return code != null && code >= 500;
  }

  static String message(Object error, {String fallback = 'Something went wrong. Please try again.'}) {
    if (isNetworkError(error)) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final msg = data['message'] ?? data['error'];
        if (msg is String && msg.trim().isNotEmpty) return msg;
        if (msg is List && msg.isNotEmpty) return msg.first.toString();
      }
      if (isServerError(error)) {
        return 'Server is having trouble right now. Please try again shortly.';
      }
    }
    return fallback;
  }
}
