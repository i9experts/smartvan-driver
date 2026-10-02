import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../session/app_session.dart';
import '../storage/token_storage.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Token is attached per request (not stored on _dio.options) so a
          // logout can never leave the previous driver's token on the client.
          final token = await TokenStorage.read();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          debugPrint('[API] -> ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API] <- ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint(
              '[API] !! ERROR ${error.response?.statusCode} ${error.requestOptions.path} — ${error.response?.data}');
          // Session expired/invalid — no screen was handling this before,
          // so a driver mid-shift would just see raw errors on every
          // request instead of a clean prompt to log back in.
          // Login itself answers 401 for a wrong password — that must show
          // an error on the login screen, not trigger a sign-out redirect.
          final isLoginCall = error.requestOptions.path.contains('/auth/login');
          if (error.response?.statusCode == 401 && !isLoginCall) {
            debugPrint('[API] 401 received — signing out');
            await AppSession.signOut(reason: '401');
          }
          handler.next(error);
        },
      ),
    );

  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  static Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  static Future<Response> put(String path, Map<String, dynamic> data) async {
    return await _dio.put(path, data: data);
  }

  static Future<Response> patch(String path, Map<String, dynamic> data) async {
    return await _dio.patch(path, data: data);
  }

  static Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  /// Uploads an image file to the dedicated /upload/image endpoint
  /// (multipart field name is 'file') and returns the resulting S3 URL.
  /// Use this BEFORE calling update-profile etc — that endpoint expects
  /// `image` as a plain string URL, not a raw file.
  static Future<String?> uploadImage(File file) async {
    final token = await TokenStorage.read();

    final uploadDio = Dio();
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      });

      final response = await uploadDio.post(
        '${AppConstants.baseUrl}/upload/image',
        data: formData,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['url'] as String?;
      }
      return null;
    } on DioException catch (e) {
      // ignore: avoid_print
      print('POST /upload/image ERROR => ${e.message} | ${e.response?.data}');
      rethrow;
    }
  }
}