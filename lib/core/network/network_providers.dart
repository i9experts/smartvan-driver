import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'api_client.dart';
import 'interceptors.dart';

/// What to do when the server says the session is no longer valid. The
/// default does nothing; the app container wires it to sign-out
/// (see core/providers/app_container.dart) so `core/network` never has to
/// import the session or any feature.
final unauthorizedHandlerProvider =
    Provider<Future<void> Function()>((ref) => () async {});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(ref.watch(tokenStorageProvider)),
    ApiLogInterceptor(),
    ErrorInterceptor(
      onUnauthorized: () => ref.read(unauthorizedHandlerProvider)(),
    ),
  ]);
  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider =
    Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));
