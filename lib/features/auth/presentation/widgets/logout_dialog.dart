import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/session/app_session.dart';
import '../../../../l10n/l10n.dart';

/// Confirmation before signing out. Warns when pickups/drops are still
/// waiting to sync, because a manual logout discards them.
Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) {
  final pending = ref.read(syncQueueProvider).pending.value;
  final l10n = context.l10n;
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.logoutTitle,
        style: const TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      content: Text(
        pending == 0 ? l10n.logoutConfirm : l10n.logoutPendingSync(pending),
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            l10n.commonCancel,
            style: const TextStyle(
                color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await AppSession.signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF4B4B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            l10n.logoutTitle,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
        ),
      ],
    ),
  );
}
