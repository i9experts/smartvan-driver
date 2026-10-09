import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/send_alert_controller.dart';

/// Bottom sheet where the driver types a message for the school admin.
Future<void> showSendAlertSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SendAlertSheet(),
  );
}

class _SendAlertSheet extends ConsumerStatefulWidget {
  const _SendAlertSheet();

  @override
  ConsumerState<_SendAlertSheet> createState() => _SendAlertSheetState();
}

class _SendAlertSheetState extends ConsumerState<_SendAlertSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      AppSnack.error(context, l10n.alertsTypeMessageFirst);
      return;
    }
    // The sheet closes before the snackbar shows, so keep the messenger.
    final messenger = ScaffoldMessenger.of(context);
    final ok =
        await ref.read(sendAlertControllerProvider.notifier).send(message);
    if (ok) {
      if (mounted) Navigator.pop(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l10n.alertsSent),
          backgroundColor: const Color(0xFF27AE60),
          behavior: SnackBarBehavior.floating,
        ));
    } else {
      final error = ref.read(sendAlertControllerProvider).error!;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content:
              Text(errorText(l10n, error, fallback: l10n.alertsSendFailed)),
          backgroundColor: const Color(0xFFFF4B4B),
          behavior: SnackBarBehavior.floating,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sending = ref.watch(sendAlertControllerProvider).isLoading;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEAECF0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.alertsSend,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.alertsSendSheetSubtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8A94A6),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.alertsMessageHint,
                hintStyle: const TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEC610),
                  foregroundColor: const Color(0xFF1B3B69),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF1B3B69)),
                      )
                    : Text(
                        l10n.alertsSend,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
