import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/fees/application/fee_payment_controller.dart';
import 'package:smartvan_driver/features/fees/application/fees_providers.dart';
import 'package:smartvan_driver/features/fees/data/fees_repository.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_payment_request.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_student.dart';
import 'package:smartvan_driver/features/fees/data/models/fee_summary.dart';
import 'package:smartvan_driver/features/fees/data/models/payment_status.dart';
import 'package:smartvan_driver/features/fees/data/models/receipt.dart';
import 'package:smartvan_driver/features/fees/presentation/screens/fee_collection_screen.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';

import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeFeesRepo extends Mock implements FeesRepository {}

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  late _FakeFeesRepo repo;
  late List<FeeStudent> students;

  setUp(() {
    repo = _FakeFeesRepo();
    students = asJsonList(unwrapData(fixture('fees/driver_students.json')))
        .map(FeeStudent.fromJson)
        .take(4)
        .toList()
        .map((s) => s.copyWith(image: null))
        .toList();
    when(() => repo.students()).thenAnswer((_) async => students);
    when(() => repo.summary()).thenAnswer((_) async => FeeSummary.fromJson(
        asJsonMap(unwrapData(fixture('fees/driver_summary.json')))));
    when(() => repo.receipt(any())).thenAnswer((_) async =>
        Receipt.fromJson(asJsonMap(unwrapData(fixture('fees/receipt.json')))));
    registerFallbackValue(const FeePaymentRequest(kidId: 'k', month: 'm'));
  });

  List<Override> overrides() =>
      [feesRepositoryProvider.overrideWithValue(repo)];

  group('providers and controller', () {
    test('feeSummary is null when the endpoint fails', () async {
      when(() => repo.summary())
          .thenAnswer((_) async => throw const ApiError(status: 404));
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect(await c.read(feeSummaryProvider.future), isNull);
    });

    test('receipt provider loads by payment id', () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect((await c.read(receiptProvider('pay-001').future)).receiptNumber,
          'RCPT-000123');
      verify(() => repo.receipt('pay-001')).called(1);
    });

    test('collect records cash, reloads and returns the new payment id',
        () async {
      when(() => repo.recordPayment(any())).thenAnswer((_) async {
        students = [
          for (final s in students)
            if (s.kidId == 'kid-002')
              s.copyWith(status: PaymentStatus.paid, paymentId: 'pay-099')
            else
              s
        ];
      });
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final sub = c.listen(feePaymentControllerProvider, (_, __) {});
      addTearDown(sub.close);
      await c.read(feeStudentsProvider.future);
      final student = students.firstWhere((s) => s.kidId == 'kid-002');

      final future =
          c.read(feePaymentControllerProvider.notifier).collect(student);
      expect(c.read(feePaymentControllerProvider),
          'kid-002'); // busy while recording
      expect(await future, 'pay-099');
      expect(c.read(feePaymentControllerProvider), isNull);
      final req = verify(() => repo.recordPayment(captureAny())).captured.single
          as FeePaymentRequest;
      expect(req.kidId, 'kid-002');
      expect(req.month, '2026-10');
    });

    test('collect rethrows the error and clears the busy state', () async {
      when(() => repo.recordPayment(any()))
          .thenThrow(const ApiError(status: 400, message: 'Already paid'));
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final sub = c.listen(feePaymentControllerProvider, (_, __) {});
      addTearDown(sub.close);
      await expectLater(
          c.read(feePaymentControllerProvider.notifier).collect(students[1]),
          throwsA(isA<ApiError>()));
      expect(c.read(feePaymentControllerProvider), isNull);
    });
  });

  Widget screen() =>
      l10nHost(const FeeCollectionScreen(), overrides: overrides());

  group('FeeCollectionScreen', () {
    testWidgets('summary card and student rows', (tester) async {
      useTallView(tester);
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Fee Collection'), findsOneWidget);
      expect(find.text('This month · 7/12 paid'), findsOneWidget);
      expect(find.text('PKR 31500'), findsOneWidget);
      expect(find.text('PKR 18000'), findsOneWidget);
      expect(find.text('PKR 22500.5'), findsOneWidget);
      expect(find.text('Collected by you'), findsOneWidget);
      expect(find.text('Test Kid One'), findsOneWidget);
      expect(find.text('Grade 3'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('Not Set Up'), findsOneWidget);
      expect(find.text('Receipt'), findsOneWidget);
      expect(find.text('Mark as Paid (Cash)'),
          findsNWidgets(2)); // overdue + pending
      expect(find.text('PKR 4500'), findsNWidgets(2));
      expect(find.text('PKR 4500.5'), findsOneWidget);
    });

    testWidgets('no summary card when the summary is unavailable',
        (tester) async {
      when(() => repo.summary())
          .thenAnswer((_) async => throw const ApiError(status: 404));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.textContaining('This month'), findsNothing);
      expect(find.text('Test Kid One'), findsOneWidget);
    });

    testWidgets('a student with no status still gets Mark as Paid',
        (tester) async {
      useTallView(tester);
      students = [
        const FeeStudent(
            kidId: 'k9', month: '2026-10', fullname: 'No Status Kid')
      ];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Not Set Up'), findsOneWidget);
      expect(find.text('Mark as Paid (Cash)'), findsOneWidget);
    });

    testWidgets('only not_generated and paid hide Mark as Paid',
        (tester) async {
      useTallView(tester);
      students = [
        const FeeStudent(
            kidId: 'a',
            month: '2026-10',
            fullname: 'A',
            status: PaymentStatus.notGenerated),
        const FeeStudent(
            kidId: 'b',
            month: '2026-10',
            fullname: 'B',
            status: PaymentStatus.paid),
      ];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Mark as Paid (Cash)'), findsNothing);
    });

    testWidgets('empty list', (tester) async {
      students = [];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(
          find.text('No students assigned to your van yet.'), findsOneWidget);
    });

    testWidgets('load error', (tester) async {
      when(() => repo.students())
          .thenAnswer((_) async => throw const NetworkException());
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Could not load students. Pull down to try again.'),
          findsOneWidget);
    });

    testWidgets('Mark as Paid: confirm, record, receipt sheet opens',
        (tester) async {
      when(() => repo.recordPayment(any())).thenAnswer((_) async {
        students = [
          for (final s in students)
            if (s.kidId == 'kid-002')
              s.copyWith(status: PaymentStatus.paid, paymentId: 'pay-099')
            else
              s
        ];
      });
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as Paid (Cash)').first);
      await tester.pumpAndSettle();
      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(
          find.text(
              "Mark Test Kid Two's transport fee as paid (cash collected)?"),
          findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      verify(() => repo.recordPayment(any())).called(1);
      expect(find.text('Payment recorded for Test Kid Two'), findsOneWidget);
      // The receipt sheet for the new payment.
      verify(() => repo.receipt('pay-099')).called(1);
      expect(find.text('RCPT-000123'), findsOneWidget);
      expect(find.text('Share on WhatsApp'), findsOneWidget);
    });

    testWidgets('cancelling the confirmation records nothing', (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as Paid (Cash)').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verifyNever(() => repo.recordPayment(any()));
    });

    testWidgets('a failed payment shows the server message', (tester) async {
      when(() => repo.recordPayment(any())).thenThrow(const ApiError(
          status: 400, message: 'Fee already paid for this month'));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as Paid (Cash)').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Fee already paid for this month'), findsOneWidget);
    });

    testWidgets('the Receipt button of a paid student opens its receipt',
        (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Receipt'));
      await tester.pumpAndSettle();
      verify(() => repo.receipt('pay-001')).called(1);
      expect(find.text('Sample School'), findsOneWidget);
      expect(find.text('PKR 4500'), findsWidgets);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('October 2026'), findsOneWidget);
    });

    testWidgets('receipt load failure shows the message', (tester) async {
      when(() => repo.receipt(any()))
          .thenAnswer((_) async => throw const ApiError(status: 404));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Could not load the receipt.'), findsOneWidget);
    });
  });
}
