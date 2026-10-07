import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/formatting/money_format.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/fees_providers.dart';
import '../../data/models/receipt.dart';
import 'fee_labels.dart';

/// Loads one receipt and shows it, with WhatsApp sharing.
class ReceiptSheet extends ConsumerWidget {
  const ReceiptSheet({super.key, required this.paymentId});

  final String paymentId;

  static Future<void> show(BuildContext context, String paymentId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ReceiptSheet(paymentId: paymentId),
    );
  }

  String _paidAt(DateTime? d, String locale) => d == null
      ? '—'
      : DateFormat('d MMM yyyy, h:mm a', locale).format(d.toLocal());

  String _month(String? v, String locale) {
    final d = DateTime.tryParse('${v ?? ''}-01');
    return d == null ? (v ?? '—') : DateFormat('MMMM yyyy', locale).format(d);
  }

  String _shareText(AppLocalizations l10n, String locale, Receipt r) {
    final amount = r.amount == null ? '—' : formatAmount(r.amount!);
    return [
      l10n.receiptShareTitle(r.schoolName ?? 'SmartVan'),
      l10n.receiptShareNumber(r.receiptNumber ?? '—'),
      l10n.receiptShareStudent(r.studentName ?? '—'),
      l10n.receiptShareMonth(_month(r.month, locale)),
      l10n.receiptShareAmount('${r.currency ?? 'PKR'} $amount'),
      l10n.receiptSharePaidVia(r.paymentMethod.label(l10n)),
      l10n.receiptShareDate(_paidAt(r.paidAt, locale)),
    ].join('\n');
  }

  Future<void> _share(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final receiptAsync = ref.watch(receiptProvider(paymentId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: receiptAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorText(l10n, error, fallback: l10n.receiptLoadFailed),
              textAlign: TextAlign.center,
            ),
          ),
          data: (r) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.receipt_long,
                  color: Color(0xFF27AE60), size: 40),
              const SizedBox(height: 6),
              Text(
                (r.schoolName ?? '').isNotEmpty
                    ? r.schoolName!
                    : l10n.receiptDefaultTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
              Text(
                '${r.currency ?? 'PKR'} ${r.amount == null ? '—' : formatAmount(r.amount!)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2B6B),
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              _Row(l10n.receiptNumber, r.receiptNumber),
              _Row(l10n.receiptStudent, r.studentName),
              if ((r.grade ?? '').isNotEmpty) _Row(l10n.receiptGrade, r.grade),
              _Row(l10n.receiptMonth, _month(r.month, locale)),
              _Row(l10n.receiptPaidVia, r.paymentMethod.label(l10n)),
              _Row(l10n.receiptDate, _paidAt(r.paidAt, locale)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _share(_shareText(l10n, locale, r)),
                icon: const Icon(Icons.share),
                label: Text(l10n.receiptShareWhatsApp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          const Spacer(),
          Flexible(
            child: Text(value ?? '—',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}
