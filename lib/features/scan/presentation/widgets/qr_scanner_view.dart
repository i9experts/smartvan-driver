import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../l10n/l10n.dart';

/// Builds the live camera view. A provider so tests can swap the platform
/// camera for a stand-in that emits codes by hand.
typedef ScannerViewBuilder = Widget Function(
  BuildContext context,
  MobileScannerController controller,
  void Function(String raw) onCode,
);

final scannerViewBuilderProvider = Provider<ScannerViewBuilder>(
  (ref) => (context, controller, onCode) => MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final raw = capture.barcodes
              .map((b) => b.rawValue)
              .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
          if (raw != null) onCode(raw);
        },
        errorBuilder: (context, error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.errorCode == MobileScannerErrorCode.permissionDenied
                  ? context.l10n.scanCameraPermission
                  : context.l10n.scanCameraFailed(error.errorCode.name),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ),
        ),
      ),
);
