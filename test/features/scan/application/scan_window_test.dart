import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartvan_driver/features/scan/application/scan_window.dart';

void main() {
  // A 400x800 phone view showing a 1080x1920 camera image (BoxFit.cover).
  const view = Size(400, 800);
  const image = Size(1080, 1920);
  final area = ScanArea.square(view);

  /// A small square code of [side] image pixels centred at [center].
  Barcode code(String raw, Offset center, {double side = 200}) => Barcode(
        rawValue: raw,
        size: image,
        corners: [
          center + Offset(-side / 2, -side / 2),
          center + Offset(side / 2, -side / 2),
          center + Offset(side / 2, side / 2),
          center + Offset(-side / 2, side / 2),
        ],
      );

  BarcodeCapture capture(List<Barcode> codes) =>
      BarcodeCapture(barcodes: codes, size: image);

  group('ScanArea.square', () {
    test('is a centred square, 70% of the shorter side', () {
      expect(area.window.width, closeTo(280, 0.001));
      expect(area.window.height, closeTo(280, 0.001));
      expect(area.window.center, const Offset(200, 400));
    });

    test('never grows past 320 px on a big screen', () {
      final big = ScanArea.square(const Size(1000, 1600));
      expect(big.window.width, 320);
    });
  });

  group('codeCenterInView', () {
    test('maps the image centre to the view centre', () {
      final c = codeCenterInView(
          corners: const [Offset(540, 960)], imageSize: image, viewSize: view)!;
      expect(c.dx, closeTo(200, 0.01));
      expect(c.dy, closeTo(400, 0.01));
    });

    test('accounts for the crop of BoxFit.cover', () {
      final c = codeCenterInView(
          corners: const [Offset(500, 500)],
          imageSize: const Size(1000, 1000),
          viewSize: view);
      // Orientation mismatch (square image is not "portrait"): unknown.
      expect(c, isNull);
      final c2 = codeCenterInView(
          corners: const [Offset(500, 600)],
          imageSize: const Size(1000, 1200),
          viewSize: view)!;
      expect(c2.dy, closeTo(400, 0.01));
    });

    test('is unknown without corners, sizes or with a rotated image', () {
      expect(
          codeCenterInView(corners: const [], imageSize: image, viewSize: view),
          isNull);
      expect(
          codeCenterInView(
              corners: const [Offset(1, 1)],
              imageSize: Size.zero,
              viewSize: view),
          isNull);
      expect(
          codeCenterInView(
              corners: const [Offset(1, 1)],
              imageSize: const Size(1920, 1080),
              viewSize: view),
          isNull);
    });
  });

  group('codeInWindow', () {
    test('a code in the middle is read', () {
      expect(codeInWindow(capture([code('A', const Offset(540, 960))]), area),
          'A');
    });

    test('a code outside the square is ignored', () {
      // Image x=100 is view x=37: well left of the square (60..340).
      expect(codeInWindow(capture([code('A', const Offset(100, 960))]), area),
          isNull);
      expect(codeInWindow(capture([code('A', const Offset(540, 200))]), area),
          isNull);
    });

    test('with several codes only the one centred in the square counts', () {
      final result = codeInWindow(
          capture([
            code('OUT', const Offset(100, 300)),
            code('IN', const Offset(600, 1000)),
            code('OUT2', const Offset(1000, 1700)),
          ]),
          area);
      expect(result, 'IN');
    });

    test('the centre decides, not the whole code', () {
      // Cover scale is 800/1920; 25 view px are cropped at the left. Put the
      // centre 5 px inside the right edge while the code itself sticks out.
      const scale = 800 / 1920;
      final x = (area.window.right - 5 + 25) / scale;
      expect(
          codeInWindow(
              capture([code('EDGE', Offset(x, 960), side: 400)]), area),
          'EDGE');
    });

    test('empty values are skipped; unknown position is trusted', () {
      expect(
          codeInWindow(
              capture([
                const Barcode(rawValue: ''),
                const Barcode(rawValue: 'NO-CORNERS'),
              ]),
              area),
          'NO-CORNERS');
      expect(
          codeInWindow(capture(const [Barcode(rawValue: null)]), area), isNull);
    });
  });
}
