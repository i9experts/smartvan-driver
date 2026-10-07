import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'json_helpers.dart';

/// Turns the (already unwrapped) response body into a model.
typedef JsonParser<T> = T Function(Object? json);

/// The whole response body, for the few endpoints that put data next to
/// `data` — e.g. `required` of `/trips/checklist/today`, `hasMore` of
/// `/chat/{id}/messages`.
class Envelope {
  const Envelope(this.raw);

  /// Body exactly as received (a map, a list, or null).
  final Object? raw;

  /// The payload, unwrapped like [unwrapData] does for the typed helpers.
  Object? get data => unwrapData(raw);

  /// A top-level key next to `data`; null when the body is not a map.
  Object? operator [](String key) => raw is Map ? (raw! as Map)[key] : null;
}

/// Turns the whole response body into a model.
typedef EnvelopeParser<T> = T Function(Envelope envelope);

/// Typed HTTP client. Repositories use [get] / [post] / [put] / [patch] /
/// [delete]: they get a parsed model back or an [AppException] thrown.
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(String path, JsonParser<T> parse,
          {Map<String, dynamic>? query}) =>
      _typed(() => _dio.get<Object?>(path, queryParameters: query), parse);

  Future<T> post<T>(String path, JsonParser<T> parse,
          {Object? body, Map<String, dynamic>? query}) =>
      _typed(() => _dio.post<Object?>(path, data: body, queryParameters: query),
          parse);

  Future<T> put<T>(String path, JsonParser<T> parse,
          {Object? body, Map<String, dynamic>? query}) =>
      _typed(() => _dio.put<Object?>(path, data: body, queryParameters: query),
          parse);

  Future<T> patch<T>(String path, JsonParser<T> parse,
          {Object? body, Map<String, dynamic>? query}) =>
      _typed(
          () => _dio.patch<Object?>(path, data: body, queryParameters: query),
          parse);

  Future<T> delete<T>(String path, JsonParser<T> parse,
          {Map<String, dynamic>? query}) =>
      _typed(() => _dio.delete<Object?>(path, queryParameters: query), parse);

  /// Like [get], but [parse] sees the whole body (see [Envelope]).
  Future<T> getEnvelope<T>(String path, EnvelopeParser<T> parse,
          {Map<String, dynamic>? query}) =>
      _typedRaw(() => _dio.get<Object?>(path, queryParameters: query), parse);

  /// Like [post], but [parse] sees the whole body (see [Envelope]).
  Future<T> postEnvelope<T>(String path, EnvelopeParser<T> parse,
          {Object? body, Map<String, dynamic>? query}) =>
      _typedRaw(
          () => _dio.post<Object?>(path, data: body, queryParameters: query),
          parse);

  /// Multipart upload to `/upload/image` (field `file`); returns the hosted
  /// URL, or null if the server answered 2xx without one.
  Future<String?> uploadImage(File file) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      });
      final response = await _dio.post<Object?>(
        '/upload/image',
        data: form,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      final body = response.data;
      return body is Map && body['url'] is String
          ? body['url'] as String
          : null;
    } on DioException catch (e) {
      throw AppException.from(e);
    }
  }

  Future<T> _typed<T>(
    Future<Response<Object?>> Function() send,
    JsonParser<T> parse,
  ) =>
      _typedRaw(send, (envelope) => parse(envelope.data));

  Future<T> _typedRaw<T>(
    Future<Response<Object?>> Function() send,
    EnvelopeParser<T> parse,
  ) async {
    final Response<Object?> response;
    try {
      response = await send();
    } on DioException catch (e) {
      throw AppException.from(e);
    }
    try {
      return parse(Envelope(response.data));
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e);
    }
  }
}
