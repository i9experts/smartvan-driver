import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/fees/data/fees_repository.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_payment_request.dart';
import 'package:smartvan_driver/features/fees/data/models/payment_method.dart';
import 'package:smartvan_driver/features/fees/data/models/payment_status.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late FeesRepository repo;

  setUp(() {
    env = ApiTestEnv();
    repo = FeesRepository(env.client);
  });

  test('students GETs /fees/driver-students', () async {
    env.adapter.onGet('/fees/driver-students',
        (s) => s.reply(200, fixture('fees/driver_students.json')));
    final list = await repo.students();
    expect(list, hasLength(6));
    expect(list.first.status, PaymentStatus.paid);
    expect(list[1].amount, 4500.5);
  });

  test('summary GETs /fees/driver-summary', () async {
    env.adapter.onGet('/fees/driver-summary',
        (s) => s.reply(200, fixture('fees/driver_summary.json')));
    final s = await repo.summary();
    expect(s.paid, 7);
    expect(s.collectedOnline, 18000.0);
  });

  test('summary: endpoint missing is an ApiError (the screen hides the card)',
      () async {
    env.adapter.onGet(
        '/fees/driver-summary', (s) => s.reply(404, {'message': 'Not Found'}));
    await expectLater(repo.summary(),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)));
  });

  test('recordPayment POSTs kidId, month and paymentMethod cash', () async {
    env.adapter.onPost(
        '/fees/record-payment', (s) => s.reply(201, {'success': true}), data: {
      'kidId': 'kid-002',
      'month': '2026-10',
      'paymentMethod': 'cash'
    });
    await repo.recordPayment(
        const FeePaymentRequest(kidId: 'kid-002', month: '2026-10'));
  });

  test('recordPayment: already paid is an ApiError with the message', () async {
    env.adapter.onPost('/fees/record-payment',
        (s) => s.reply(400, {'message': 'Fee already paid for this month'}),
        data: Matchers.any);
    await expectLater(
        repo.recordPayment(
            const FeePaymentRequest(kidId: 'k', month: '2026-10')),
        throwsA(isA<ApiError>().having((e) => e.userMessage, 'message',
            'Fee already paid for this month')));
  });

  test('receipt GETs /fees/receipt/{paymentId}', () async {
    env.adapter.onGet('/fees/receipt/pay-001',
        (s) => s.reply(200, fixture('fees/receipt.json')));
    final r = await repo.receipt('pay-001');
    expect(r.receiptNumber, 'RCPT-000123');
    expect(r.paymentMethod, PaymentMethod.cash);
  });

  test('receipt: unknown id is an ApiError', () async {
    env.adapter.onGet('/fees/receipt/nope',
        (s) => s.reply(404, {'message': 'Receipt not found'}));
    await expectLater(
        repo.receipt('nope'),
        throwsA(isA<ApiError>()
            .having((e) => e.userMessage, 'message', 'Receipt not found')));
  });
}
