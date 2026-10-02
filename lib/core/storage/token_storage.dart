import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Stores the auth token in the platform keystore (Android Keystore /
/// iOS Keychain) instead of plain-text SharedPreferences.
///
/// The token is cached in memory after the first read so the Dio
/// interceptor doesn't hit secure storage on every request.
class TokenStorage {
  TokenStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static String? _cached;
  static bool _loaded = false;

  static Future<String?> read() async {
    if (_loaded) return _cached;
    try {
      _cached = await _storage.read(key: AppConstants.tokenKey);
    } catch (e) {
      debugPrint('[TokenStorage] secure read failed: $e');
      _cached = null;
    }

    // One-time migration: older builds kept the token in SharedPreferences.
    // Move it over so existing drivers don't get logged out by this update.
    if (_cached == null) {
      final prefs = await SharedPreferences.getInstance();
      final legacy = prefs.getString(AppConstants.tokenKey);
      if (legacy != null && legacy.isNotEmpty) {
        await save(legacy);
        await prefs.remove(AppConstants.tokenKey);
      }
    }
    _loaded = true;
    return _cached;
  }

  static Future<void> save(String token) async {
    _cached = token;
    _loaded = true;
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  static Future<void> clear() async {
    _cached = null;
    _loaded = true;
    try {
      await _storage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      debugPrint('[TokenStorage] secure delete failed: $e');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await read();
    return token != null && token.isNotEmpty;
  }
}
