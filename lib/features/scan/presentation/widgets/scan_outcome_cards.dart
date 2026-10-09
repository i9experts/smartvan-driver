import 'package:flutter/material.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../passengers/data/models/scan_result.dart';
import '../../application/scan_state.dart';

const _green = Color(0xFF27AE60);
const _navy = Color(0xFF1B3B69);
const _red = Color(0xFFE53935);
const _amber = Color(0xFFFEC610);

/// What the result card shows for an [ScanOutcome].
class _View {
  const _View(this.title, this.subtitle, this.icon, this.color);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

_View _viewOf(BuildContext context, ScanOutcome outcome) {
  final l10n = context.l10n;
  switch (outcome) {
    case ScanNotACard():
      return _View(l10n.scanNotACardTitle, l10n.scanNotACardBody,
          Icons.qr_code_2, _amber);
    case ScanNoActiveTrip():
      return _View(
          l10n.scanNoTripTitle, l10n.scanNoTripBody, Icons.error_outline, _red);
    case ScanSucceeded(:final result):
      final picked = result.action == ScanAction.picked;
      return _View(
        result.fullname.isEmpty ? l10n.scanStudentFallback : result.fullname,
        picked ? l10n.scanPickedUp : l10n.scanDroppedOff,
        picked ? Icons.arrow_upward : Icons.home,
        picked ? _green : _navy,
      );
    case ScanOffline():
      return _View(l10n.scanErrNoInternetTitle, l10n.scanErrNoInternetBody,
          Icons.error_outline, _amber);
    case ScanFailed(:final code, :final error):
      final title = switch (code) {
        'INVALID_QR' => l10n.scanErrInvalidQr,
        'KID_NOT_ON_TRIP' => l10n.scanErrKidNotOnTrip,
        'ALREADY_PICKED' => l10n.scanErrAlreadyPicked,
        'ALREADY_DROPPED' => l10n.scanErrAlreadyDropped,
        'LOCATION_REQUIRED' => l10n.scanErrLocationRequired,
        'TRIP_NOT_ONGOING' => l10n.scanErrTripNotOngoing,
        _ => l10n.scanErrDefaultTitle,
      };
      return _View(
          title,
          errorText(l10n, error, fallback: l10n.scanErrDefaultBody),
          Icons.error_outline,
          _red);
  }
}

class ScanHintCard extends StatelessWidget {
  const ScanHintCard({super.key, required this.scannedCount});

  final int scannedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      key: const ValueKey('hint'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        scannedCount == 0
            ? l10n.scanHintFirst
            : l10n.scanHintSession(scannedCount),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      ),
    );
  }
}

class ScanOutcomeCard extends StatelessWidget {
  const ScanOutcomeCard({super.key, required this.outcome});

  final ScanOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final v = _viewOf(context, outcome);
    return Container(
      key: ValueKey('${v.title}${v.subtitle}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: v.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(v.icon, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(v.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins')),
                Text(v.subtitle,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
