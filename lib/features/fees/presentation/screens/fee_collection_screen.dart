import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/fee_payment_controller.dart';
import '../../application/fees_providers.dart';
import '../../data/models/fee_student.dart';
import '../widgets/fee_student_card.dart';
import '../widgets/fee_summary_card.dart';
import '../widgets/receipt_sheet.dart';

class FeeCollectionScreen extends ConsumerWidget {
  const FeeCollectionScreen({super.key});

  Future<void> _collect(
      BuildContext context, WidgetRef ref, FeeStudent student) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.feesConfirmTitle),
        content: Text(l10n.feesConfirmBody(student.fullname)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60)),
            child: Text(l10n.feesConfirm,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final paymentId = await ref
          .read(feePaymentControllerProvider.notifier)
          .collect(student);
      if (!context.mounted) return;
      AppSnack.success(context, l10n.feesPaymentRecorded(student.fullname));
      // Offer the receipt straight away so the driver can share it.
      if (paymentId != null) await ReceiptSheet.show(context, paymentId);
    } catch (e) {
      if (context.mounted) {
        AppSnack.error(
            context, errorText(l10n, e, fallback: l10n.feesPaymentFailed));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final studentsAsync = ref.watch(feeStudentsProvider);
    final summary = ref.watch(feeSummaryProvider).valueOrNull;
    final payingKidId = ref.watch(feePaymentControllerProvider);

    Future<void> refresh() async {
      ref.invalidate(feeSummaryProvider);
      await ref
          .refresh(feeStudentsProvider.future)
          .catchError((_) => <FeeStudent>[]);
    }

    final Widget body;
    if (studentsAsync.hasValue && studentsAsync.requireValue.isNotEmpty) {
      final students = studentsAsync.requireValue;
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return summary == null
                ? const SizedBox.shrink()
                : FeeSummaryCard(summary: summary);
          }
          final s = students[index - 1];
          return FeeStudentCard(
            student: s,
            busy: payingKidId == s.kidId,
            onCollect: () => _collect(context, ref, s),
            onShowReceipt: (id) => ReceiptSheet.show(context, id),
          );
        },
      );
    } else if (studentsAsync.hasValue) {
      body = ListView(
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.groups_outlined, size: 48, color: Color(0xFF8A94A6)),
          const SizedBox(height: 12),
          Center(
            child: Text(l10n.feesEmpty,
                style: const TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
        ],
      );
    } else if (studentsAsync.hasError) {
      body = ListView(
        children: [
          const SizedBox(height: 120),
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Center(
            child: Text(l10n.feesLoadFailed,
                style: const TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
        ],
      );
    } else {
      body = const AppLoading();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B6B),
        title: Text(l10n.feesTitle,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(onRefresh: refresh, child: body),
    );
  }
}
