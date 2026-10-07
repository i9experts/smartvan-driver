import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which backend flavour the app was built for. Chosen with
/// `--dart-define=FLAVOR=staging`; production is the default.
enum AppFlavor {
  production,
  staging;

  static AppFlavor parse(String value) => AppFlavor.values.firstWhere(
        (f) => f.name == value,
        orElse: () => AppFlavor.production,
      );
}

/// Build-time configuration.
///
/// ```
/// flutter run --dart-define=API_BASE_URL=https://staging.example \
///             --dart-define=SOCKET_URL=https://staging.example
/// ```
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.socketUrl,
    this.flavor = AppFlavor.production,
  });

  /// Default backend, used when no `--dart-define` is given.
  static const String defaultApiBaseUrl = 'https://api.smartvan.pk';

  static const String _apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: defaultApiBaseUrl);
  static const String _socketUrl =
      String.fromEnvironment('SOCKET_URL', defaultValue: _apiBaseUrl);
  static const String _flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'production');

  /// Values baked into this build.
  static final AppConfig current = AppConfig(
    apiBaseUrl: _apiBaseUrl,
    socketUrl: _socketUrl,
    flavor: AppFlavor.parse(_flavor),
  );

  final String apiBaseUrl;
  final String socketUrl;
  final AppFlavor flavor;
}

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);
