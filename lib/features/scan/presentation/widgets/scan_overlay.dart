import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const _green = Color(0xFF27AE60);
const _radius = 20.0;

/// What sits over the camera: everything outside [window] dimmed, bracket
/// corners on the square, and a green border that blinks each time
/// [detections] changes (a code was read inside the square).
class ScanOverlay extends StatefulWidget {
  const ScanOverlay(
      {super.key, required this.window, required this.detections});

  final Rect window;
  final ValueListenable<int> detections;

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    reverseDuration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    widget.detections.addListener(_flash);
  }

  @override
  void didUpdateWidget(ScanOverlay old) {
    super.didUpdateWidget(old);
    if (old.detections != widget.detections) {
      old.detections.removeListener(_flash);
      widget.detections.addListener(_flash);
    }
  }

  @override
  void dispose() {
    widget.detections.removeListener(_flash);
    _blink.dispose();
    super.dispose();
  }

  void _flash() {
    _blink.forward(from: 0).whenComplete(() {
      if (mounted) _blink.reverse();
    });
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _blink,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _OverlayPainter(widget.window, _blink.value),
          ),
        ),
      );
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter(this.window, this.flash);

  final Rect window;

  /// 0 = idle, 1 = fully green.
  final double flash;

  @override
  void paint(Canvas canvas, Size size) {
    final hole =
        RRect.fromRectAndRadius(window, const Radius.circular(_radius));
    final dim = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(hole);
    canvas.drawPath(dim, Paint()..color = Colors.black.withValues(alpha: 0.6));

    // Thin outline, turning green on a detection.
    canvas.drawRRect(
      hole,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 + 3 * flash
        ..color =
            Color.lerp(Colors.white.withValues(alpha: 0.35), _green, flash)!,
    );

    // Bracket corners.
    const arm = 30.0;
    final corner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..color = Color.lerp(Colors.white, _green, flash)!;
    final r = window;
    final path = Path()
      ..moveTo(r.left, r.top + arm)
      ..lineTo(r.left, r.top + _radius)
      ..arcToPoint(Offset(r.left + _radius, r.top),
          radius: const Radius.circular(_radius))
      ..lineTo(r.left + arm, r.top)
      ..moveTo(r.right - arm, r.top)
      ..lineTo(r.right - _radius, r.top)
      ..arcToPoint(Offset(r.right, r.top + _radius),
          radius: const Radius.circular(_radius))
      ..lineTo(r.right, r.top + arm)
      ..moveTo(r.right, r.bottom - arm)
      ..lineTo(r.right, r.bottom - _radius)
      ..arcToPoint(Offset(r.right - _radius, r.bottom),
          radius: const Radius.circular(_radius))
      ..lineTo(r.right - arm, r.bottom)
      ..moveTo(r.left + arm, r.bottom)
      ..lineTo(r.left + _radius, r.bottom)
      ..arcToPoint(Offset(r.left, r.bottom - _radius),
          radius: const Radius.circular(_radius))
      ..lineTo(r.left, r.bottom - arm);
    canvas.drawPath(path, corner);
  }

  @override
  bool shouldRepaint(_OverlayPainter old) =>
      old.window != window || old.flash != flash;
}
