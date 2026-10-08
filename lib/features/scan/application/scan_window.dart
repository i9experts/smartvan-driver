import 'dart:math' as math;
import 'package:flutter/painting.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// The camera view and the square inside it that the scanner reads.
class ScanArea {
  const ScanArea({required this.size, required this.window});

  /// The whole camera view, in logical pixels.
  final Size size;

  /// The square the driver aims at, in the same coordinates as [size].
  final Rect window;

  /// The square for a view of [size]: centred, about 70% of the shorter side.
  factory ScanArea.square(Size size) {
    final side =
        (math.min(size.width, size.height) * 0.7).clamp(0.0, 320.0).toDouble();
    return ScanArea(
      size: size,
      window: Rect.fromCenter(
          center: size.center(Offset.zero), width: side, height: side),
    );
  }
}

/// Where a code's centre sits in the camera view (the view shows the image
/// with `BoxFit.cover`), or null when that cannot be told: no corners, no
/// image size, or an image whose orientation does not match the view's.
Offset? codeCenterInView({
  required List<Offset> corners,
  required Size imageSize,
  required Size viewSize,
}) {
  if (corners.isEmpty || imageSize.isEmpty || viewSize.isEmpty) return null;
  if ((imageSize.width < imageSize.height) !=
      (viewSize.width < viewSize.height)) {
    return null;
  }
  final scale = math.max(
      viewSize.width / imageSize.width, viewSize.height / imageSize.height);
  final dx = (viewSize.width - imageSize.width * scale) / 2;
  final dy = (viewSize.height - imageSize.height * scale) / 2;
  var sx = 0.0, sy = 0.0;
  for (final c in corners) {
    sx += c.dx;
    sy += c.dy;
  }
  return Offset(
    sx / corners.length * scale + dx,
    sy / corners.length * scale + dy,
  );
}

/// The text of the first code in [capture] whose centre is inside
/// [area]'s square; codes outside it are ignored. The platform already
/// reads only inside the square (`scanWindow`); this settles a frame with
/// several codes. A code whose position is unknown is accepted, since the
/// platform only reported it from inside the square.
String? codeInWindow(BarcodeCapture capture, ScanArea area) {
  for (final barcode in capture.barcodes) {
    final raw = barcode.rawValue;
    if (raw == null || raw.isEmpty) continue;
    final imageSize = barcode.size.isEmpty ? capture.size : barcode.size;
    final center = codeCenterInView(
        corners: barcode.corners, imageSize: imageSize, viewSize: area.size);
    if (center == null || area.window.contains(center)) return raw;
  }
  return null;
}
