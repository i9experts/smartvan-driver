import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/checklist/data/checklist_repository.dart';
import 'package:smartvan_driver/features/checklist/data/models/checklist_answer.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late ChecklistRepository repo;
  final f = fixtureMap('checklist/checklist.json');

  setUp(() {
    env = ApiTestEnv();
    repo = ChecklistRepository(env.client);
  });

  test('items GETs the questions', () async {
    env.adapter
        .onGet('/trips/checklist/items', (s) => s.reply(200, f['items']));
    final items = await repo.items();
    expect(items.map((i) => i.key), ['tyres', 'brakes']);
  });

  test('today keeps `required`, which sits next to `data`', () async {
    env.adapter
        .onGet('/trips/checklist/today', (s) => s.reply(200, f['todayDone']));
    final t = await repo.today();
    expect(t.required, isTrue);
    expect(t.done, isTrue);
    expect(t.allOk, isFalse);
  });

  test('today when nothing was submitted', () async {
    env.adapter.onGet(
        '/trips/checklist/today', (s) => s.reply(200, f['todayNotDone']));
    final t = await repo.today();
    expect(t.done, isFalse);
    expect(t.required, isFalse);
  });

  test('submit POSTs routeId, items (note only when given) and photoUrl',
      () async {
    env.adapter.onPost(
      '/trips/checklist',
      (s) => s.reply(201, {'success': true}),
      data: {
        'routeId': 'route-001',
        'items': [
          {'key': 'tyres', 'ok': true},
          {'key': 'brakes', 'ok': false, 'note': 'Pedal feels soft'},
        ],
        'photoUrl': 'https://example.test/img/van-check.png',
      },
    );
    await repo.submit(
      routeId: 'route-001',
      answers: const [
        ChecklistAnswer(key: 'tyres', ok: true),
        ChecklistAnswer(key: 'brakes', ok: false, note: 'Pedal feels soft'),
      ],
      photoUrl: 'https://example.test/img/van-check.png',
    );
  });

  test('submit without routeId or photo sends only items', () async {
    env.adapter.onPost(
      '/trips/checklist',
      (s) => s.reply(201, {}),
      data: {
        'items': [
          {'key': 'tyres', 'ok': true}
        ]
      },
    );
    await repo.submit(answers: const [ChecklistAnswer(key: 'tyres', ok: true)]);
  });

  test('submit: rejected body is an ApiError', () async {
    env.adapter.onPost('/trips/checklist',
        (s) => s.reply(400, {'message': 'Items are required'}),
        data: Matchers.any);
    await expectLater(
        repo.submit(answers: const []),
        throwsA(isA<ApiError>()
            .having((e) => e.userMessage, 'message', 'Items are required')));
  });
}
