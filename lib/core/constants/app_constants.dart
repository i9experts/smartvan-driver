import '../config/app_config.dart';

class AppConstants {
  // Same compile-time values as AppConfig (API_BASE_URL / SOCKET_URL
  // --dart-define); kept for code that has not moved to appConfigProvider yet.
  static const String baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: AppConfig.defaultApiBaseUrl);
  static const String socketUrl =
      String.fromEnvironment('SOCKET_URL', defaultValue: baseUrl);
  static const String tokenKey = 'auth_token';
  static const String userTypeKey = 'user_type';
}
