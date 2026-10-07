import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/sos_controller.dart';
import '../../data/emergency_numbers.dart';

/// Red SOS button. Must be held for [holdDuration] to fire, so it can't be
/// triggered by an accidental tap while driving.
class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key});

  static const holdDuration = Duration(milliseconds: 1500);

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton>
    with SingleTickerProviderStateMixin {
  static const _red = Color(0xFFE53935);

  late final AnimationController _hold =
      AnimationController(vsync: this, duration: SosButton.holdDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _send();
        });

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  void _startHold() {
    if (ref.read(sosControllerProvider)) return;
    HapticFeedback.mediumImpact();
    _hold.forward(from: 0);
  }

  void _cancelHold() {
    if (_hold.status != AnimationStatus.completed) _hold.reverse();
  }

  Future<void> _send() async {
    HapticFeedback.heavyImpact();
    final l10n = context.l10n;
    final outcome = await ref.read(sosControllerProvider.notifier).send();
    if (!mounted) return;
    _hold.reset();
    switch (outcome) {
      case SosNoLocation():
        _showResult(false, l10n.sosNoLocationTitle, l10n.sosNoLocationBody);
      case SosSent(:final parentsNotified):
        _showResult(true, l10n.sosSentTitle, l10n.sosSentBody(parentsNotified));
      case SosRateLimited(:final error):
        _showResult(true, l10n.sosAlreadyTitle, errorText(l10n, error));
      case SosFailed(:final error):
        _showResult(false, l10n.sosFailedTitle,
            l10n.sosFailedBody(errorText(l10n, error)));
    }
  }

  void _showResult(bool ok, String title, String body) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(ok ? Icons.check_circle : Icons.error,
                  color: ok ? const Color(0xFF27AE60) : _red, size: 48),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 6),
              Text(body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              Row(
                children: [
                  _callButton(l10n.sosPolice, EmergencyNumbers.police),
                  const SizedBox(width: 8),
                  _callButton(l10n.sosRescue, EmergencyNumbers.rescue),
                  const SizedBox(width: 8),
                  _callButton(l10n.sosEdhi, EmergencyNumbers.edhi),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _callButton(String label, String number) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => EmergencyNumbers.call(number),
        style: OutlinedButton.styleFrom(
          foregroundColor: _red,
          side: const BorderSide(color: _red),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
            Text(number,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sending = ref.watch(sosControllerProvider);
    return Semantics(
      button: true,
      label: l10n.sosSemantics,
      child: GestureDetector(
        onLongPressStart: (_) => _startHold(),
        onLongPressEnd: (_) => _cancelHold(),
        onLongPressCancel: _cancelHold,
        onTap: () {
          if (sending) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.sosHoldHint),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ));
        },
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _hold,
                builder: (_, __) => SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: sending ? null : _hold.value,
                    strokeWidth: 4,
                    color: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: _red.withValues(alpha: 0.4), blurRadius: 12),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(l10n.sosButtonLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
