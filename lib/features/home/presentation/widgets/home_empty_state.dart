import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// "No Trip Today" — also what a driver without a van sees.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFF1B3B69).withOpacity(0.1),
                const Color(0xFF2D4099).withOpacity(0.05),
              ]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_outlined,
                size: 44, color: Color(0xFF1B3B69)),
          ),
          const SizedBox(height: 20),
          Text(l10n.homeEmptyTitle,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Text(l10n.homeEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A94A6),
                  fontFamily: 'Poppins',
                  height: 1.6)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEC610).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: const Color(0xFFFEC610).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFFFEC610), size: 16),
                const SizedBox(width: 6),
                Text(l10n.homeEmptyNotified,
                    style: const TextStyle(
                        color: Color(0xFFFEC610),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
