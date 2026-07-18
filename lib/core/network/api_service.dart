import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../router/app_router.dart';

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
        onRequest: (options, handler) {
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
          if (error.response?.statusCode == 401) {
            debugPrint('[API] 401 received — clearing token and redirecting to /login');
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(AppConstants.tokenKey);
            appRouter.go('/login');
          }
          handler.next(error);
        },
      ),
    );

  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> _addAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static Future<Response> get(String path) async {
    await _addAuthHeader();
    return await _dio.get(path);
  }

  static Future<Response> post(String path, Map<String, dynamic> data) async {
    await _addAuthHeader();
    return await _dio.post(path, data: data);
  }

  static Future<Response> put(String path, Map<String, dynamic> data) async {
    await _addAuthHeader();
    return await _dio.put(path, data: data);
  }

  static Future<Response> patch(String path, Map<String, dynamic> data) async {
    await _addAuthHeader();
    return await _dio.patch(path, data: data);
  }

  static Future<Response> delete(String path) async {
    await _addAuthHeader();
    return await _dio.delete(path);
  }

  /// Uploads an image file to the dedicated /upload/image endpoint
  /// (multipart field name is 'file') and returns the resulting S3 URL.
  /// Use this BEFORE calling update-profile etc — that endpoint expects
  /// `image` as a plain string URL, not a raw file.
  static Future<String?> uploadImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

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