import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_payment_request.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_student.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_summary.dart';
import 'package:smartvan_driver/features/fees/data/models/payment_method.dart';
import 'package:smartvan_driver/features/fees/data/models/payment_status.dart';
import 'package:smartvan_driver/features/fees/data/models/receipt.dart';

import '../../../../support/fixture.dart';

void main() {
  group('FeeStudent', () {
    final list = asJsonList(unwrapData(fixture('fees/driver_students.json')))
        .map(FeeStudent.fromJson)
        .toList();

    test('a paid student', () {
      final s = list[0];
      expect(s.kidId, 'kid-001');
      expect(s.month, '2026-10');
      expect(s.fullname, 'Test Kid One');
      expect(s.image, 'https://example.test/img/1.png');
      expect(s.grade, '3');
      expect(s.status, PaymentStatus.paid);
      expect(s.amount, 4500.0);
      expect(s.currency, 'PKR');
      expect(s.paymentId, 'pay-001');
    });

    test('amount as numeric string, grade as number', () {
      expect(list[1].status, PaymentStatus.overdue);
      expect(list[1].amount, 4500.5);
      expect(list[1].grade, '4');
      expect(list[1].paymentId, isNull);
    });

    test('pending, not_generated', () {
      expect(list[2].status, PaymentStatus.pending);
      expect(list[3].status, PaymentStatus.notGenerated);
      expect(list[3].amount, isNull);
    });

    test('unknown status; missing status defaults to not generated', () {
      expect(list[4].status, PaymentStatus.unknown); // "refunded"
      expect(list[4].fullname, 'Test Kid Five'); // `name`
      expect(list[5].status, PaymentStatus.notGenerated);
    });
  });

  test('FeeSummary absorbs number-as-string', () {
    final s = FeeSummary.fromJson(
        asJsonMap(unwrapData(fixture('fees/driver_summary.json'))));
    expect(s.currency, 'PKR');
    expect(s.paid, 7);
    expect(s.students, 12);
    expect(s.collectedByYou, 31500.0);
    expect(s.collectedOnline, 18000.0); // "18000"
    expect(s.totalPending, 22500.5);
  });

  test('FeeSummary of an empty object is all zeros, not null', () {
    final s = FeeSummary.fromJson({});
    expect(s.paid, 0);
    expect(s.students, 0);
    expect(s.totalPending, 0.0);
  });

  group('Receipt', () {
    test('parses a receipt', () {
      final r =
          Receipt.fromJson(asJsonMap(unwrapData(fixture('fees/receipt.json'))));
      expect(r.schoolName, 'Sample School');
      expect(r.currency, 'PKR');
      expect(r.amount, 4500.0);
      expect(r.receiptNumber, 'RCPT-000123');
      expect(r.studentName, 'Test Kid One');
      expect(r.grade, '3');
      expect(r.month, '2026-10');
      expect(r.paymentMethod, PaymentMethod.cash);
      expect(r.paidAt, DateTime.utc(2026, 10, 6, 9, 30));
    });

    test('every payment method, and an unknown one', () {
      for (final m
          in PaymentMethod.values.where((m) => m != PaymentMethod.unknown)) {
        final json =
            FeePaymentRequest(kidId: 'k', month: '2026-10', paymentMethod: m)
                .toJson();
        expect(
            Receipt.fromJson({'paymentMethod': json['paymentMethod']})
                .paymentMethod,
            m);
      }
      expect(Receipt.fromJson({'paymentMethod': 'barter'}).paymentMethod,
          PaymentMethod.unknown);
      expect(Receipt.fromJson({}).paymentMethod, PaymentMethod.unknown);
    });
  });

  test('FeePaymentRequest records cash by default', () {
    expect(
        const FeePaymentRequest(kidId: 'kid-001', month: '2026-10').toJson(), {
      'kidId': 'kid-001',
      'month': '2026-10',
      'paymentMethod': 'cash',
    });
    expect(
        const FeePaymentRequest(
                kidId: 'k',
                month: '2026-10',
                paymentMethod: PaymentMethod.bankTransfer)
            .toJson()['paymentMethod'],
        'bank_transfer');
  });
}
