import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/sync/sync_queue.dart';
import '../../trip/services/trip_tracking_service.dart';
import '../scan_service.dart';

/// Continuous scanner for student QR cards. Each successful scan shows a
/// result card for a moment, then scanning resumes — so a line of kids can
/// board one after another.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ResultView {
  final bool ok;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _ResultView(this.ok, this.title, this.subtitle, this.icon, this.color);
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  static const _green = Color(0xFF27AE60);
  static const _navy = Color(0xFF1B2B6B);
  static const _red = Color(0xFFE53935);
  static const _amber = Color(0xFFFFB800);

  final MobileScannerController _controller = MobileScannerController(
    // Not noDuplicates: on a drop trip the same card is scanned twice
    // (pick at school, drop at home). Repeats are filtered in _onDetect.
    detectionSpeed: DetectionSpeed.normal,
    formats: const [BarcodeFormat.qrCode],
  );

  bool _busy = false;
  String? _lastPayload;
  DateTime? _lastAt;
  _ResultView? _result;
  Timer? _resultTimer;
  final List<ScanResult> _session = [];

  @override
  void dispose() {
    _resultTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;
    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (raw == null) return;

    // Same card still in front of the camera — ignore for a few seconds.
    final now = DateTime.now();
    if (raw == _lastPayload &&
        _lastAt != null &&
        now.difference(_lastAt!) < const Duration(seconds: 4)) {
      return;
    }
    _lastPayload = raw;
    _lastAt = now;

    if (!ScanService.looksLikeCard(raw)) {
      _show(const _ResultView(false, 'Not a SmartVan card',
          'Scan the student\'s SmartVan QR card.', Icons.qr_code_2, _amber));
      return;
    }

    final tracking = ref.read(tripTrackingProvider);
    final tripId = tracking.tripId;
    if (tripId == null) {
      _show(const _ResultView(false, 'No active trip',
          'Start a trip before scanning.', Icons.error_outline, _red));
      return;
    }

    setState(() => _busy = true);
    HapticFeedback.selectionClick();
    try {
      // Any offline picks/drops must reach the server first, otherwise the
      // server could decide pick vs drop from stale state.
      await SyncQueue.instance.flush();
      final position =
          await ref.read(tripTrackingProvider.notifier).currentPosition();
      final result = await ScanService.scan(
        tripId: tripId,
        qrPayload: raw,
        lat: position?.latitude,
        lng: position?.longitude,
      );
      _session.insert(0, result);
      HapticFeedback.heavyImpact();
      final picked = result.action == 'picked';
      _show(_ResultView(
        true,
        result.fullname,
        picked ? 'Picked up' : 'Dropped off',
        picked ? Icons.arrow_upward : Icons.home,
        picked ? _green : _navy,
      ));
    } on ScanException catch (e) {
      HapticFeedback.vibrate();
      _show(_ResultView(false, _titleFor(e.code), e.message,
          Icons.error_outline, e.code == 'NETWORK' ? _amber : _red));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _titleFor(String? code) {
    switch (code) {
      case 'INVALID_QR':
        return 'Card not recognised';
      case 'KID_NOT_ON_TRIP':
        return 'Not on this van';
      case 'ALREADY_PICKED':
        return 'Already picked up';
      case 'ALREADY_DROPPED':
        return 'Already dropped';
      case 'LOCATION_REQUIRED':
        return 'GPS needed';
      case 'TRIP_NOT_ONGOING':
        return 'Trip not in progress';
      case 'NETWORK':
        return 'No internet';
      default:
        return 'Scan failed';
    }
  }

  void _show(_ResultView view) {
    if (!mounted) return;
    _resultTimer?.cancel();
    setState(() => _result = view);
    _resultTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _result = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Scan student card',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(_session.isNotEmpty),
        ),
        actions: [
          IconButton(
            tooltip: 'Torch',
            icon: const Icon(Icons.flashlight_on_outlined),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  error.errorCode == MobileScannerErrorCode.permissionDenied
                      ? 'Camera permission is needed to scan cards. Enable it in app settings.'
                      : 'Camera could not start (${error.errorCode.name}).',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
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
          if (_busy)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          // Result card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _result == null
                  ? _hintCard()
                  : _resultCard(_result!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hintCard() {
    return Container(
      key: const ValueKey('hint'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        _session.isEmpty
            ? 'Point the camera at the student\'s QR card.'
            : '${_session.length} scanned this session. Keep scanning.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _resultCard(_ResultView r) {
    return Container(
      key: ValueKey('${r.title}${r.subtitle}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: r.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(r.icon, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(r.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins')),
                Text(r.subtitle,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
