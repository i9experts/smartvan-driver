import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/l10n.dart';

/// Back arrow, trip name and the Live / Offline pill.
class TripHeader extends StatelessWidget {
  const TripHeader({
    super.key,
    required this.title,
    required this.connected,
    required this.onBack,
  });

  final String title;
  final bool connected;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const green = Color(0xFF27AE60);
    return GradientHeader(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: connected
                  ? green.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: connected ? green : Colors.white30),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: connected ? green : Colors.white30,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  connected ? l10n.tripLive : l10n.tripOffline,
                  style: TextStyle(
                    color: connected ? green : Colors.white54,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
