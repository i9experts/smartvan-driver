import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/fees_repository.dart';
import '../data/models/fee_student.dart';
import '../data/models/fee_summary.dart';
import '../data/models/receipt.dart';

part 'fees_providers.g.dart';

/// Every kid on the van with this month's fee status.
@riverpod
Future<List<FeeStudent>> feeStudents(Ref ref) =>
    ref.watch(feesRepositoryProvider).students();

/// This month's totals. Null when the endpoint is unavailable — the card is
/// simply not shown then.
@riverpod
Future<FeeSummary?> feeSummary(Ref ref) async {
  try {
    return await ref.watch(feesRepositoryProvider).summary();
  } catch (_) {
    return null;
  }
}

/// One payment receipt.
@riverpod
Future<Receipt> receipt(Ref ref, String paymentId) =>
    ref.watch(feesRepositoryProvider).receipt(paymentId);
