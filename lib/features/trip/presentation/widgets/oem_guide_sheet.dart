import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../application/battery_guard.dart';

/// One-time explanation for phones that stop background apps: what to allow,
/// with a button straight to the right settings screen.
class OemGuideSheet extends StatelessWidget {
  const OemGuideSheet({super.key, required this.guide, required this.onOpen});

  final OemGuide guide;
  final VoidCallback onOpen;

  static Future<void> show(
          BuildContext context, OemGuide guide, VoidCallback onOpen) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => OemGuideSheet(guide: guide, onOpen: onOpen),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.battery_alert,
                  size: 36, color: Color(0xFFFEC610)),
              const SizedBox(height: 12),
              Text(l10n.tripBatteryGuideTitle(guide.brand),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              Text(l10n.tripBatteryGuideBody(guide.brand),
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A5568),
                      fontFamily: 'Poppins')),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onOpen();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3B69),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.tripBatteryGuideOpen),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.tripBatteryGuideLater,
                      style: const TextStyle(
                          color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
