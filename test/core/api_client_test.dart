import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/config/app_config.dart';
import 'package:smartvan_driver/core/network/api_client.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/core/network/network_providers.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';

class _FakeTokenStore extends Mock implements TokenStore {}

void main() {
  late _FakeTokenStore tokens;
  late int unauthorizedCalls;
  late ProviderContainer container;
  late DioAdapter adapter;

  setUp(() {
    tokens = _FakeTokenStore();
    when(() => tokens.read()).thenAnswer((_) async => 'tkn');
    unauthorizedCalls = 0;
    container = ProviderContainer(overrides: [
      appConfigProvider.overrideWithValue(const AppConfig(
          apiBaseUrl: 'http://api.test', socketUrl: 'http://api.test')),
      tokenStorageProvider.overrideWithValue(tokens),
      unauthorizedHandlerProvider
          .overrideWithValue(() async => unauthorizedCalls++),
    ]);
    addTearDown(container.dispose);
    adapter = DioAdapter(dio: container.read(dioProvider));
  });

  ApiClient client() => container.read(apiClientProvider);

  group('typed helpers', () {
    test('get parses the unwrapped body, whatever the envelope', () async {
      adapter
        ..onGet(
            '/a',
            (s) => s.reply(200, {
                  'data': {'n': 1}
                }))
        ..onGet(
            '/b',
            (s) => s.reply(200, {
                  'data': {
                    'data': {'n': 2}
                  }
                }))
        ..onGet('/c', (s) => s.reply(200, {'n': 3}))
        ..onGet(
            '/d',
            (s) => s.reply(200, [
                  {'n': 4}
                ]));

      int n(Object? j) => asJsonMap(j)['n'] as int;
      expect(await client().get('/a', n), 1);
      expect(await client().get('/b', n), 2);
      expect(await client().get('/c', n), 3);
      expect(await client().get('/d', (j) => asJsonList(j).single['n']), 4);
    });

    test('post sends the body and query', () async {
      adapter.onPost(
          '/trips/startTrip',
          (s) => s.reply(201, {
                'data': {'id': 't1'}
              }),
          data: {'routeId': 'r1', 'type': 'pick'},
          queryParameters: {'x': '1'});
      final id = await client().post(
          '/trips/startTrip', (j) => asJsonMap(j)['id'] as String,
          body: {'routeId': 'r1', 'type': 'pick'}, query: {'x': '1'});
      expect(id, 't1');
    });

    test('put, patch and delete', () async {
      adapter
        ..onPut('/p', (s) => s.reply(200, {'data': 'put'}), data: Matchers.any)
        ..onPatch('/p', (s) => s.reply(200, {'data': 'patch'}),
            data: Matchers.any)
        ..onDelete('/p', (s) => s.reply(200, {'data': 'delete'}));
      String s(Object? j) => j! as String;
      expect(await client().put('/p', s, body: {}), 'put');
      expect(await client().patch('/p', s, body: {}), 'patch');
      expect(await client().delete('/p', s), 'delete');
    });

    test('attaches the Bearer token', () async {
      adapter.onGet('/auth', (s) => s.reply(200, {'data': 1}),
          headers: {'Authorization': 'Bearer tkn'});
      expect(await client().get('/auth', (j) => j), 1);
    });

    test('no token, no Authorization header', () async {
      when(() => tokens.read()).thenAnswer((_) async => null);
      Object? seen;
      adapter.onGet('/open', (s) => s.reply(200, {'data': 1}));
      container
          .read(dioProvider)
          .interceptors
          .add(InterceptorsWrapper(onRequest: (o, h) {
        seen = o.headers['Authorization'];
        h.next(o);
      }));
      await client().get('/open', (j) => j);
      expect(seen, isNull);
    });

    test('parse failures become UnknownException', () async {
      adapter.onGet('/bad', (s) => s.reply(200, {'data': 'not a map'}));
      expect(client().get('/bad', asJsonMap), throwsA(isA<UnknownException>()));
    });
  });

  group('envelope helpers', () {
    test('getEnvelope exposes data and top-level siblings', () async {
      adapter.onGet(
          '/trips/checklist/today',
          (s) => s.reply(200, {
                'required': true,
                'data': {'allOk': true}
              }));
      final result = await client().getEnvelope('/trips/checklist/today',
          (e) => (e['required'], asJsonMap(e.data)['allOk']));
      expect(result, (true, true));
    });

    test('getEnvelope on a raw list: data is the list, siblings are null',
        () async {
      adapter.onGet('/raw', (s) => s.reply(200, [1, 2]));
      final result =
          await client().getEnvelope('/raw', (e) => (e.data, e['hasMore']));
      expect(result.$1, [1, 2]);
      expect(result.$2, isNull);
    });

    test('postEnvelope sends the body', () async {
      adapter.onPost(
          '/chat/c1/messages',
          (s) => s.reply(201, {
                'data': {'id': 1},
                'hasMore': false
              }),
          data: {'text': 'hi'});
      final more = await client().postEnvelope(
          '/chat/c1/messages', (e) => e['hasMore'],
          body: {'text': 'hi'});
      expect(more, false);
    });

    test('errors still map to AppException', () async {
      adapter.onGet('/e', (s) => s.reply(409, {'code': 'X', 'message': 'm'}));
      expect(client().getEnvelope('/e', (e) => e),
          throwsA(isA<ApiError>().having((e) => e.code, 'code', 'X')));
    });
  });

  group('error mapping', () {
    test('4xx with a code becomes ApiError', () async {
      adapter.onPost(
          '/trips/endTrip',
          (s) => s.reply(409, {
                'message': 'Kids still on board',
                'code': 'KIDS_NOT_DROPPED',
                'kids': [
                  {'kidId': 'k1', 'fullname': 'Ali'}
                ]
              }),
          data: Matchers.any);
      await expectLater(
        client().post('/trips/endTrip', (j) => j, body: {'tripId': 't'}),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', 'KIDS_NOT_DROPPED')
            .having((e) => e.status, 'status', 409)
            .having((e) => e.userMessage, 'message', 'Kids still on board')),
      );
    });

    test('5xx becomes ServerException', () async {
      adapter.onGet('/boom', (s) => s.reply(500, {'message': 'x'}));
      expect(client().get('/boom', (j) => j), throwsA(isA<ServerException>()));
    });

    test('connection failure becomes NetworkException', () async {
      adapter.onGet(
          '/down',
          (s) => s.throws(
              0,
              DioException.connectionError(
                  requestOptions: RequestOptions(path: '/down'),
                  reason: 'no route')));
      expect(client().get('/down', (j) => j), throwsA(isA<NetworkException>()));
    });

    test('401 signs out, except on /auth/login', () async {
      adapter
        ..onGet('/me', (s) => s.reply(401, {'message': 'expired'}))
        ..onPost(
            '/auth/login', (s) => s.reply(401, {'message': 'Wrong password'}),
            data: Matchers.any);

      await expectLater(
          client().get('/me', (j) => j), throwsA(isA<UnauthorizedException>()));
      expect(unauthorizedCalls, 1);

      await expectLater(
          client().post('/auth/login', (j) => j, body: {}),
          throwsA(isA<UnauthorizedException>()
              .having((e) => e.userMessage, 'message', 'Wrong password')));
      expect(unauthorizedCalls, 1);
    });
  });

  group('legacy raw helpers', () {
    test('return the Response and keep DioException with the AppException',
        () async {
      adapter
        ..onGet('/ok', (s) => s.reply(200, {'data': 1}))
        ..onGet('/err', (s) => s.reply(400, {'message': 'nope'}));
      final res = await client().getRaw('/ok');
      expect(res.statusCode, 200);
      expect(res.data, {'data': 1});

      try {
        await client().getRaw('/err');
        fail('should throw');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 400);
        expect(e.error, isA<ApiError>());
      }
    });
  });
}
