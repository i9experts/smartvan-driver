import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// What a numbered stop pin looks like.
class StopMarkerStyle {
  const StopMarkerStyle({
    required this.number,
    required this.color,
    this.crossedOut = false,
    this.highlighted = false,
  });

  final int number;
  final Color color;

  /// A red pin with a line through it (kid absent / no-show).
  final bool crossedOut;

  /// The next stop: bigger, with a navy ring.
  final bool highlighted;

  @override
  bool operator ==(Object other) =>
      other is StopMarkerStyle &&
      other.number == number &&
      other.color == color &&
      other.crossedOut == crossedOut &&
      other.highlighted == highlighted;

  @override
  int get hashCode => Object.hash(number, color, crossedOut, highlighted);
}

/// Makes a stop pin. A parameter so tests need no real image encoding.
typedef StopIconFactory = Future<BitmapDescriptor>
    Function(StopMarkerStyle style, {required double devicePixelRatio});

const stopIconLogicalSize = 30.0;
const highlightedStopIconLogicalSize = 40.0;

/// Draws a round numbered pin at [devicePixelRatio] times its logical size.
Future<BitmapDescriptor> createStopIcon(StopMarkerStyle style,
    {required double devicePixelRatio}) async {
  final logical =
      style.highlighted ? highlightedStopIconLogicalSize : stopIconLogicalSize;
  final pixels = (logical * devicePixelRatio).round();
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = pixels.toDouble();
  final centre = Offset(s / 2, s / 2);
  final radius = s / 2 - s * 0.06;

  final fill = Paint()..style = PaintingStyle.fill;
  canvas.drawCircle(centre, radius, fill..color = style.color);
  canvas.drawCircle(
    centre,
    radius,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * (style.highlighted ? 0.12 : 0.08)
      ..color = style.highlighted ? const Color(0xFF1B3B69) : Colors.white,
  );

  final text = TextPainter(
    text: TextSpan(
      text: '${style.number}',
      style: TextStyle(
        color: style.color.computeLuminance() > 0.6
            ? const Color(0xFF1B3B69)
            : Colors.white,
        fontSize: s * 0.46,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  text.paint(canvas, centre - Offset(text.width / 2, text.height / 2));

  if (style.crossedOut) {
    canvas.drawLine(
      Offset(s * 0.2, s * 0.8),
      Offset(s * 0.8, s * 0.2),
      Paint()
        ..color = Colors.white
        ..strokeWidth = s * 0.09
        ..strokeCap = StrokeCap.round,
    );
  }

  final image = await recorder.endRecording().toImage(pixels, pixels);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return BytesMapBitmap(
    bytes!.buffer.asUint8List(),
    imagePixelRatio: devicePixelRatio,
  );
}
