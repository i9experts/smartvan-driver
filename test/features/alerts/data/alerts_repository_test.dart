import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/alerts/data/alerts_repository.dart';
import 'package:smartvan_driver/features/alerts/data/models/alert_type.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late AlertsRepository repo;
  final shapes = fixtureMap('alerts/alerts_shapes.json');

  setUp(() {
    env = ApiTestEnv();
    repo = AlertsRepository(env.client);
  });

  group('alerts', () {
    test('GETs the driver notifications and parses {data: [...]}', () async {
      env.adapter.onGet('/alert/getNotificationForDriver',
          (s) => s.reply(200, shapes['dataList']));
      final alerts = await repo.alerts();
      expect(alerts, hasLength(5));
      expect(alerts.first.type, AlertType.payment);
    });

    test('also parses a raw list and {data: {notifications: []}}', () async {
      env.adapter.onGet('/alert/getNotificationForDriver',
          (s) => s.reply(200, shapes['rawList']));
      expect((await repo.alerts()).single.type, AlertType.sos);

      env.adapter.onGet('/alert/getNotificationForDriver',
          (s) => s.reply(200, shapes['dataNotifications']));
      expect((await repo.alerts()).single.type, AlertType.profile);
    });

    test('server error maps to ServerException', () async {
      env.adapter
          .onGet('/alert/getNotificationForDriver', (s) => s.reply(503, {}));
      await expectLater(repo.alerts(), throwsA(isA<ServerException>()));
    });
  });

  test('sendAlert POSTs the message', () async {
    env.adapter.onPost(
        '/alert/sendAlertByDriver', (s) => s.reply(201, {'success': true}),
        data: {'message': 'Van will be 10 minutes late'});
    await repo.sendAlert('Van will be 10 minutes late');
  });

  test('sendAlert surfaces the server message', () async {
    env.adapter.onPost('/alert/sendAlertByDriver',
        (s) => s.reply(400, {'message': 'Message is required'}),
        data: Matchers.any);
    await expectLater(
        repo.sendAlert(''),
        throwsA(isA<ApiError>()
            .having((e) => e.userMessage, 'message', 'Message is required')));
  });
}
