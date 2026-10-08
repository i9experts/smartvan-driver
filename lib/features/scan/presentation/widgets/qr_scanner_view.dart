import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../l10n/l10n.dart';
import '../../application/scan_window.dart';

/// Builds the live camera view, reading only inside [ScanArea.window]; [onCode]
/// gets the text of a code whose centre is in it. A provider so tests can swap
/// the platform camera for a stand-in that emits codes by hand.
typedef ScannerViewBuilder = Widget Function(
  BuildContext context,
  MobileScannerController controller,
  ScanArea area,
  void Function(String raw) onCode,
);

final scannerViewBuilderProvider = Provider<ScannerViewBuilder>(
  (ref) => (context, controller, area, onCode) => MobileScanner(
        controller: controller,
        // The platform reads only inside the square the overlay draws.
        scanWindow: area.window,
        onDetect: (capture) {
          final raw = codeInWindow(capture, area);
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
