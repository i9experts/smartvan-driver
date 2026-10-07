import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_container.dart';
import 'network_providers.dart';

/// Legacy static facade over [ApiClient] (docs/ARCHITECTURE.md §3). Screens
/// that have not been migrated yet keep calling it; it is deleted once the
/// last one is.
class ApiService {
  static final _client = appContainer.read(apiClientProvider);

  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<Response> get(String path) => _client.getRaw(path);

  static Future<Response> post(String path, Map<String, dynamic> data) =>
      _client.postRaw(path, data);

  static Future<Response> put(String path, Map<String, dynamic> data) =>
      _client.putRaw(path, data);

  static Future<Response> patch(String path, Map<String, dynamic> data) =>
      _client.patchRaw(path, data);

  static Future<Response> delete(String path) => _client.deleteRaw(path);

  /// Uploads an image file to the dedicated /upload/image endpoint
  /// (multipart field name is 'file') and returns the resulting S3 URL.
  /// Use this BEFORE calling update-profile etc — that endpoint expects
  /// `image` as a plain string URL, not a raw file.
  static Future<String?> uploadImage(File file) => _client.uploadImageRaw(file);
}
