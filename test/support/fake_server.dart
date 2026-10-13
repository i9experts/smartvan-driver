import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:smartvan_driver/core/network/api_client.dart';
import 'package:smartvan_driver/core/network/interceptors.dart';

/// A server whose connection and answers the test controls.
class FakeServer implements HttpClientAdapter {
  bool up = true;

  /// Every try, also the ones that never connected.
  int attempts = 0;

  /// Answers by path; default 201.
  final Map<String, ({int status, Object body})> answers = {};
  final List<({String path, Map<String, dynamic> body})> requests = [];

  Iterable<Map<String, dynamic>> posts(String path) =>
      requests.where((r) => r.path == path).map((r) => r.body);

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    attempts++;
    if (!up) {
      throw DioException.connectionError(
          requestOptions: options, reason: 'offline');
    }
    requests.add((
      path: options.path,
      body: Map<String, dynamic>.from(options.data as Map),
    ));
    final answer = answers[options.path] ?? (status: 201, body: {'ok': true});
    return ResponseBody.fromString(jsonEncode(answer.body), answer.status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        });
  }

  @override
  void close({bool force = false}) {}
}

/// A Dio on a [FakeServer], with the production error interceptor, wrapped in
/// the app's typed client.
ApiClient fakeServerClient(FakeServer server) {
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = server;
  dio.interceptors.add(ErrorInterceptor(onUnauthorized: () async {}));
  return ApiClient(dio);
}
