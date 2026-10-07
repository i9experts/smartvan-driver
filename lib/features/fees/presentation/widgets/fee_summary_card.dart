import 'package:flutter/material.dart';
import '../../../../core/formatting/money_format.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/fee_summary.dart';

/// This month's totals: paid count and collected / online / pending money.
class FeeSummaryCard extends StatelessWidget {
  const FeeSummaryCard({super.key, required this.summary});

  final FeeSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cur = summary.currency ?? 'PKR';
    Widget stat(String label, String value, Color color) => Expanded(
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                      fontFamily: 'Poppins')),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A94A6),
                      fontFamily: 'Poppins')),
            ],
          ),
        );
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.feesSummaryHeading(summary.paid, summary.students),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          const SizedBox(height: 12),
          Row(
            children: [
              stat(
                  l10n.feesCollectedByYou,
                  formatMoney(cur, summary.collectedByYou),
                  const Color(0xFF27AE60)),
              stat(
                  l10n.feesPaidOnline,
                  formatMoney(cur, summary.collectedOnline),
                  const Color(0xFF1B2B6B)),
              stat(l10n.feesPending, formatMoney(cur, summary.totalPending),
                  const Color(0xFFFFB800)),
            ],
          ),
        ],
      ),
    );
  }
}
