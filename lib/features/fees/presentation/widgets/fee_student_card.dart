import 'package:flutter/material.dart';
import '../../../../core/formatting/money_format.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/fee_student.dart';
import '../../data/models/payment_status.dart';

class FeeStatusBadge extends StatelessWidget {
  const FeeStatusBadge({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (Color bg, Color fg, String label) = switch (status) {
      PaymentStatus.paid => (
          const Color(0xFFE8F8EE),
          const Color(0xFF27AE60),
          l10n.feesStatusPaid
        ),
      PaymentStatus.overdue => (
          const Color(0xFFFDEAEA),
          const Color(0xFFFF4B4B),
          l10n.feesStatusOverdue
        ),
      PaymentStatus.pending => (
          const Color(0xFFFFF6E5),
          const Color(0xFFFFB800),
          l10n.feesStatusPending
        ),
      _ => (
          const Color(0xFFF0F0F0),
          const Color(0xFF8A94A6),
          l10n.feesStatusNotSetUp
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins')),
    );
  }
}

/// One kid's fee row: name, status, amount, receipt or "Mark as Paid".
class FeeStudentCard extends StatelessWidget {
  const FeeStudentCard({
    super.key,
    required this.student,
    required this.busy,
    required this.onCollect,
    required this.onShowReceipt,
  });

  final FeeStudent student;
  final bool busy;
  final VoidCallback onCollect;
  final void Function(String paymentId) onShowReceipt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = student;
    final isPaid = s.status == PaymentStatus.paid;
    final name = s.fullname.isEmpty ? l10n.feesUnknownStudent : s.fullname;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF1B2B6B).withValues(alpha: 0.1),
                backgroundImage:
                    s.image != null ? NetworkImage(s.image!) : null,
                child: s.image == null
                    ? Text(
                        s.fullname.isNotEmpty
                            ? s.fullname[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: Color(0xFF1B2B6B),
                            fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 15)),
                    if (s.grade != null)
                      Text(l10n.feesGrade(s.grade!),
                          style: const TextStyle(
                              color: Color(0xFF8A94A6),
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                  ],
                ),
              ),
              FeeStatusBadge(status: s.status),
            ],
          ),
          if (s.amount != null) ...[
            const SizedBox(height: 10),
            Text(
              formatMoney(s.currency ?? 'PKR', s.amount!),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF1B2B6B)),
            ),
          ],
          if (isPaid && s.paymentId != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => onShowReceipt(s.paymentId!),
                icon: const Icon(Icons.receipt_long, size: 18),
                label: Text(l10n.feesReceipt),
              ),
            ),
          if (!isPaid && s.status != PaymentStatus.notGenerated) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: busy ? null : onCollect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l10n.feesMarkPaidCash,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
