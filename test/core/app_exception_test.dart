import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';

DioException dioError({
  int? status,
  Object? body,
  DioExceptionType type = DioExceptionType.badResponse,
  Object? error,
}) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: type,
    error: error,
    response: status == null
        ? null
        : Response(requestOptions: req, statusCode: status, data: body),
  );
}

void main() {
  test('timeouts and connection errors are NetworkException', () {
    for (final t in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      expect(AppException.from(dioError(type: t)), isA<NetworkException>());
    }
    expect(
        AppException.from(const SocketException('x')), isA<NetworkException>());
    expect(
        AppException.from(dioError(
            type: DioExceptionType.unknown, error: const SocketException('x'))),
        isA<NetworkException>());
  });

  test('NetworkException.userMessage is the offline text', () {
    expect(const NetworkException().userMessage,
        'No internet connection. Please check your network and try again.');
  });

  test('401 is UnauthorizedException and keeps the server message', () {
    final e = AppException.from(
        dioError(status: 401, body: {'message': 'Token expired'}));
    expect(e, isA<UnauthorizedException>());
    expect(e.userMessage, 'Token expired');
    expect(AppException.from(dioError(status: 401)).userMessage,
        'Your session has expired. Please log in again.');
  });

  test('5xx is ServerException with default or server text', () {
    final plain = AppException.from(dioError(status: 502));
    expect(plain, isA<ServerException>());
    expect(plain.userMessage,
        'Server is having trouble right now. Please try again shortly.');
    expect(
        AppException.from(dioError(status: 500, body: {'message': 'Boom'}))
            .userMessage,
        'Boom');
  });

  test('4xx is ApiError carrying code, message, status and body', () {
    final body = {
      'message': 'Some kids are still on the van',
      'code': 'KIDS_NOT_DROPPED',
      'kids': [
        {'kidId': 'k1', 'fullname': 'Ali'}
      ],
    };
    final e = AppException.from(dioError(status: 409, body: body));
    expect(e, isA<ApiError>());
    e as ApiError;
    expect(e.code, 'KIDS_NOT_DROPPED');
    expect(e.status, 409);
    expect(e.userMessage, 'Some kids are still on the van');
    expect((e.data as Map)['kids'], hasLength(1));
  });

  test('message can be a list, or sit under "error"', () {
    expect(
        AppException.from(dioError(status: 400, body: {
          'message': ['first', 'second']
        })).userMessage,
        'first');
    expect(
        AppException.from(dioError(status: 400, body: {'error': 'Bad Request'}))
            .userMessage,
        'Bad Request');
  });

  test('4xx without a body falls back to the generic text', () {
    final e = AppException.from(dioError(status: 404));
    expect(e, isA<ApiError>());
    expect(e.userMessage, 'Something went wrong. Please try again.');
  });

  test('anything else is UnknownException; AppException passes through', () {
    expect(AppException.from(StateError('x')), isA<UnknownException>());
    const original = ServerException('s', 500);
    expect(AppException.from(original), same(original));
    expect(AppException.from(dioError(status: 400, error: original)),
        same(original));
  });

  group('guardAppException', () {
    test('passes the value through', () async {
      expect(await guardAppException(() async => 42), 42);
    });

    test('DioException becomes an AppException', () async {
      await expectLater(
          guardAppException<void>(
              () async => throw dioError(status: 409, body: {'code': 'X'})),
          throwsA(isA<ApiError>().having((e) => e.code, 'code', 'X')));
    });

    test('an AppException inside a DioException is kept', () async {
      const original = ServerException('s', 500);
      await expectLater(
          guardAppException<void>(
              () async => throw dioError(status: 500, error: original)),
          throwsA(same(original)));
    });

    test('SocketException becomes NetworkException', () async {
      await expectLater(
          guardAppException<void>(() async => throw const SocketException('x')),
          throwsA(isA<NetworkException>()));
    });

    test('other errors are not swallowed', () async {
      await expectLater(
          guardAppException<void>(() async => throw StateError('bug')),
          throwsA(isA<StateError>()));
    });
  });
}
