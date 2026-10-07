import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';

import '../../../support/api_env.dart';

void main() {
  late ApiTestEnv env;
  late AuthRepository repo;

  setUp(() {
    env = ApiTestEnv();
    repo = AuthRepository(env.client);
  });

  group('login', () {
    test('POSTs trimmed loginId, password and userType; reads data.token',
        () async {
      env.adapter.onPost(
        '/auth/login',
        (s) => s.reply(201, {
          'message': 'Login successful',
          'data': {'token': 'fake-jwt', 'fullname': 'Test Driver'},
        }),
        data: {
          'loginId': 'driver@example.test',
          'password': 'secret',
          'userType': 'driver'
        },
      );
      expect(
          await repo.login(
              loginId: '  driver@example.test ', password: 'secret'),
          'fake-jwt');
    });

    test('also accepts a top-level token', () async {
      env.adapter.onPost(
          '/auth/login', (s) => s.reply(200, {'token': 'top-level'}),
          data: Matchers.any);
      expect(await repo.login(loginId: 'x', password: 'y'), 'top-level');
    });

    test('2xx without a token is an ApiError', () async {
      env.adapter.onPost('/auth/login', (s) => s.reply(200, {'data': {}}),
          data: Matchers.any);
      await expectLater(
          repo.login(loginId: 'x', password: 'y'),
          throwsA(isA<ApiError>()
              .having((e) => e.code, 'code', 'NO_TOKEN')
              .having((e) => e.userMessage, 'message',
                  'Login failed. Please try again.')));
    });

    test('wrong password: UnauthorizedException with the server message',
        () async {
      env.adapter.onPost('/auth/login',
          (s) => s.reply(401, {'message': 'Invalid credentials'}),
          data: Matchers.any);
      await expectLater(
          repo.login(loginId: 'x', password: 'bad'),
          throwsA(isA<UnauthorizedException>()
              .having((e) => e.userMessage, 'message', 'Invalid credentials')));
    });

    test('offline: NetworkException', () async {
      env.adapter.onPost(
          '/auth/login', (s) => s.throws(0, connectionError('/auth/login')),
          data: Matchers.any);
      await expectLater(repo.login(loginId: 'x', password: 'y'),
          throwsA(isA<NetworkException>()));
    });
  });

  test('changePassword POSTs old/new password and userType', () async {
    env.adapter.onPost(
      '/auth/change-password',
      (s) => s.reply(200, {'message': 'ok'}),
      data: {
        'oldPassword': 'old',
        'newPassword': 'new-secret',
        'userType': 'driver'
      },
    );
    await repo.changePassword(oldPassword: 'old', newPassword: 'new-secret');
  });

  test('changePassword: wrong old password is an ApiError with the message',
      () async {
    env.adapter.onPost('/auth/change-password',
        (s) => s.reply(400, {'message': 'Old password is incorrect'}),
        data: Matchers.any);
    await expectLater(
        repo.changePassword(oldPassword: 'x', newPassword: 'y'),
        throwsA(isA<ApiError>().having(
            (e) => e.userMessage, 'message', 'Old password is incorrect')));
  });

  test('registerFcmToken POSTs fcmToken and userType to /van/update-profile',
      () async {
    env.adapter.onPost(
      '/van/update-profile',
      (s) => s.reply(200, {'success': true}),
      data: {'fcmToken': 'fcm-123', 'userType': 'driver'},
    );
    await repo.registerFcmToken('fcm-123');
  });
}
