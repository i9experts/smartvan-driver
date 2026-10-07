import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/l10n.dart';

/// Back arrow, title, scan button and the Total / Picked / Remaining chips.
class PassengersHeader extends StatelessWidget {
  const PassengersHeader({
    super.key,
    required this.total,
    required this.picked,
    required this.onBack,
    required this.onScan,
  });

  final int total;
  final int picked;
  final VoidCallback onBack;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientHeader(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: onBack,
              ),
              Text(
                l10n.passengersTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.scanTitle,
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                onPressed: onScan,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 16),
              _Stat(l10n.passengersTotal, '$total', const Color(0xFFFFB800)),
              const SizedBox(width: 12),
              _Stat(l10n.passengersPickedLabel, '$picked', const Color(0xFF27AE60)),
              const SizedBox(width: 12),
              _Stat(l10n.passengersRemaining, '${total - picked}', Colors.white70),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
