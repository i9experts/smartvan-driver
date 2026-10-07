import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/config/app_config.dart';
import 'package:smartvan_driver/core/constants/app_constants.dart';

void main() {
  test('defaults to the production backend', () {
    expect(AppConfig.current.apiBaseUrl, 'https://api.smartvan.pk');
    expect(AppConfig.current.socketUrl, 'https://api.smartvan.pk');
    expect(AppConfig.current.flavor, AppFlavor.production);
  });

  test('AppConstants stays in step with AppConfig', () {
    expect(AppConstants.baseUrl, AppConfig.current.apiBaseUrl);
    expect(AppConstants.socketUrl, AppConfig.current.socketUrl);
  });

  test('unknown flavor falls back to production', () {
    expect(AppFlavor.parse('staging'), AppFlavor.staging);
    expect(AppFlavor.parse('nope'), AppFlavor.production);
  });

  test('appConfigProvider can be overridden in tests', () {
    final c = ProviderContainer(overrides: [
      appConfigProvider.overrideWithValue(const AppConfig(
          apiBaseUrl: 'http://test', socketUrl: 'http://test-socket')),
    ]);
    addTearDown(c.dispose);
    expect(c.read(appConfigProvider).apiBaseUrl, 'http://test');
  });
}
