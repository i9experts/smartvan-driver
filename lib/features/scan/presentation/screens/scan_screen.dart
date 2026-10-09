import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../l10n/l10n.dart';
import '../../application/scan_controller.dart';
import '../../application/scan_state.dart';
import '../../application/scan_window.dart';
import '../widgets/qr_scanner_view.dart';
import '../widgets/scan_outcome_cards.dart';
import '../widgets/scan_overlay.dart';

/// Continuous scanner for student QR cards. Each successful scan shows a
/// result card for a moment, then scanning resumes — so a line of kids can
/// board one after another. Pops `true` if anything was scanned.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  static const _navy = Color(0xFF1B3B69);

  final MobileScannerController _controller = MobileScannerController(
    // Not noDuplicates: on a drop trip the same card is scanned twice
    // (pick at school, drop at home). Repeats are filtered by the controller.
    detectionSpeed: DetectionSpeed.normal,
    formats: const [BarcodeFormat.qrCode],
  );

  /// Counts codes read inside the square; the overlay blinks on each.
  final ValueNotifier<int> _detections = ValueNotifier(0);

  void _onCode(String raw) {
    _detections.value++;
    ref.read(scanControllerProvider.notifier).onCode(raw);
  }

  @override
  void dispose() {
    _detections.dispose();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final area = ScanArea.square(constraints.biggest);
          return Stack(
            children: [
              ref.watch(scannerViewBuilderProvider)(
                  context, _controller, area, _onCode),
              ScanOverlay(window: area.window, detections: _detections),
              if (scan.busy)
                const Center(
                    child: CircularProgressIndicator(color: Colors.white)),
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
          );
        },
      ),
    );
  }
}
