import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../l10n/l10n.dart';
import '../../application/scan_controller.dart';
import '../../application/scan_state.dart';
import '../widgets/qr_scanner_view.dart';
import '../widgets/scan_outcome_cards.dart';

/// Continuous scanner for student QR cards. Each successful scan shows a
/// result card for a moment, then scanning resumes — so a line of kids can
/// board one after another. Pops `true` if anything was scanned.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  static const _navy = Color(0xFF1B2B6B);

  final MobileScannerController _controller = MobileScannerController(
    // Not noDuplicates: on a drop trip the same card is scanned twice
    // (pick at school, drop at home). Repeats are filtered by the controller.
    detectionSpeed: DetectionSpeed.normal,
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scan = ref.watch(scanControllerProvider);

    // Haptics follow what the controller decided.
    ref.listen(scanControllerProvider.select((s) => s.outcome), (prev, next) {
      switch (next) {
        case ScanSucceeded():
          HapticFeedback.heavyImpact();
        case ScanFailed() || ScanOffline():
          HapticFeedback.vibrate();
        default:
          break;
      }
    });
    ref.listen(scanControllerProvider.select((s) => s.busy), (_, busy) {
      if (busy) HapticFeedback.selectionClick();
    });

    final outcome = scan.outcome;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(l10n.scanTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(scan.session.isNotEmpty),
        ),
        actions: [
          IconButton(
            tooltip: l10n.scanTorch,
            icon: const Icon(Icons.flashlight_on_outlined),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          ref.watch(scannerViewBuilderProvider)(
            context,
            _controller,
            (raw) => ref.read(scanControllerProvider.notifier).onCode(raw),
          ),
          // Viewfinder
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          if (scan.busy)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: outcome == null
                  ? ScanHintCard(scannedCount: scan.session.length)
                  : ScanOutcomeCard(outcome: outcome),
            ),
          ),
        ],
      ),
    );
  }
}
