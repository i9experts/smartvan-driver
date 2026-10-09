import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// Warnings over the map: location sharing off, updates saved offline.
class TripBanners extends StatelessWidget {
  const TripBanners({
    super.key,
    required this.isTracking,
    required this.pending,
    required this.onTurnOn,
  });

  final bool isTracking;
  final int pending;
  final VoidCallback onTurnOn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final warnings = <Widget>[
      if (!isTracking)
        _Banner(
          icon: Icons.location_off,
          text: l10n.tripLocationOff,
          color: const Color(0xFFFF4B4B),
          action: TextButton(
            onPressed: onTurnOn,
            child: Text(l10n.tripTurnOn,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Poppins')),
          ),
        ),
      if (pending > 0)
        _Banner(
          icon: Icons.cloud_off,
          text: l10n.tripSavedOffline(pending),
          color: const Color(0xFFFEC610),
        ),
    ];
    if (warnings.isEmpty) return const SizedBox.shrink();
    return Column(mainAxisSize: MainAxisSize.min, children: warnings);
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.text,
    required this.color,
    this.action,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
