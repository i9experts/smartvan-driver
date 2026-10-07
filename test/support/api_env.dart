import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/api_client.dart';
import 'package:smartvan_driver/core/network/interceptors.dart';

/// A real [ApiClient] on a real Dio (with the production error interceptor)
/// whose transport is mocked, for repository tests.
class ApiTestEnv {
  ApiTestEnv._(this.dio, this.adapter) : client = ApiClient(dio);

  factory ApiTestEnv() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    dio.interceptors.add(ErrorInterceptor(onUnauthorized: () async {}));
    // Match on path + method + body; ignore header differences.
    final adapter = DioAdapter(dio: dio);
    return ApiTestEnv._(dio, adapter);
  }

  final Dio dio;
  final DioAdapter adapter;
  final ApiClient client;

  /// The last request that reached the transport (method, path, body, query).
  /// Wraps [Dio] with a recording interceptor; call before making requests.
  RequestOptions? lastRequest;

  void record() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      lastRequest = o;
      h.next(o);
    }));
  }
}

/// What Dio throws when the phone has no connection.
DioException connectionError(String path) => DioException.connectionError(
    requestOptions: RequestOptions(path: path), reason: 'offline');
