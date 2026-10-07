import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/fees_repository.dart';
import '../data/models/fee_payment_request.dart';
import '../data/models/fee_student.dart';
import 'fees_providers.dart';

part 'fee_payment_controller.g.dart';

/// Records cash payments. State is the kidId being paid right now (null when
/// idle), so the list can show a spinner on that row only.
@riverpod
class FeePaymentController extends _$FeePaymentController {
  @override
  String? build() => null;

  /// Records [student]'s fee as paid in cash, reloads the list and totals and
  /// returns the new payment id (for the receipt), or null if the refreshed
  /// list has none. Throws the `AppException` if recording fails.
  Future<String?> collect(FeeStudent student) async {
    state = student.kidId;
    try {
      await ref.read(feesRepositoryProvider).recordPayment(
            FeePaymentRequest(kidId: student.kidId, month: student.month),
          );
      ref.invalidate(feeSummaryProvider);
      ref.invalidate(feeStudentsProvider);
      final students = await ref.read(feeStudentsProvider.future);
      return students
          .where((s) => s.kidId == student.kidId)
          .map((s) => s.paymentId)
          .firstOrNull;
    } finally {
      state = null;
    }
  }
}
