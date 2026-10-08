import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartvan_driver/core/map/animated_van_marker.dart';
import 'package:smartvan_driver/core/map/van_icon.dart';
import 'package:smartvan_driver/core/map/van_pose_animator.dart';

void main() {
  const start = LatLng(24.8607, 67.0011);
  const north = LatLng(24.8608, 67.0011);
  final fakeIcon = BitmapDescriptor.defaultMarkerWithHue(10);

  Set<Marker> markers = {};
  final poses = <VanPose>[];
  final ratios = <double>[];

  Widget host(
    LatLng? position, {
    double? speed,
    double ratio = 2.0,
    VanIconFactory? iconFactory,
  }) =>
      MediaQuery(
        data: MediaQueryData(devicePixelRatio: ratio),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVanMarker(
            position: position,
            speedMetersPerSecond: speed,
            title: 'Your Location',
            onPose: poses.add,
            iconFactory: iconFactory ??
                ({required devicePixelRatio}) async {
                  ratios.add(devicePixelRatio);
                  return fakeIcon;
                },
            builder: (context, m) {
              markers = m;
              return const SizedBox();
            },
          ),
        ),
      );

  setUp(() {
    markers = {};
    poses.clear();
    ratios.clear();
  });

  testWidgets('no marker until the first fix', (tester) async {
    await tester.pumpWidget(host(null));
    expect(markers, isEmpty);
  });

  testWidgets('the van is a flat, centre-anchored marker with the van icon',
      (tester) async {
    await tester.pumpWidget(host(start));
    await tester.pump();
    final m = markers.single;
    expect(m.position, start);
    expect(m.flat, isTrue);
    expect(m.anchor, const Offset(0.5, 0.5));
    expect(m.rotation, 0);
    expect(m.infoWindow.title, 'Your Location');
    expect(m.icon, fakeIcon);
  });

  testWidgets('the icon is made for the screen\'s pixel ratio', (tester) async {
    await tester.pumpWidget(host(start, ratio: 3.0));
    await tester.pump();
    expect(ratios, [3.0]);
    await tester.pumpWidget(host(start, ratio: 2.0));
    await tester.pump();
    expect(ratios, [3.0, 2.0]);
  });

  testWidgets('until the icon is ready, or if it fails, the pin is used',
      (tester) async {
    await tester.pumpWidget(host(start,
        iconFactory: ({required devicePixelRatio}) async =>
            throw StateError('no encoder')));
    await tester.pump();
    expect(markers.single.icon, isNot(fakeIcon));
    expect(markers.single.icon, isA<BitmapDescriptor>());
  });

  testWidgets('a new fix glides there and reports every frame', (tester) async {
    await tester.pumpWidget(host(start));
    await tester.pumpWidget(host(north, speed: 8));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final mid = markers.single.position.latitude;
    expect(mid, greaterThan(start.latitude));
    expect(mid, lessThan(north.latitude));
    await tester.pump(const Duration(milliseconds: 600));
    expect(markers.single.position, north);
    expect(markers.single.rotation, closeTo(0, 0.01));
    expect(poses.length, greaterThan(2));
    expect(poses.last.position, north);
  });

  testWidgets('disposing mid-animation leaves nothing running', (tester) async {
    await tester.pumpWidget(host(start));
    await tester.pumpWidget(host(north, speed: 8));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox());
    expect(tester.hasRunningAnimations, isFalse);
  });

  group('the van icon', () {
    testWidgets('is drawn at the pixel ratio as a PNG', (tester) async {
      final icon =
          await tester.runAsync(() => createVanIcon(devicePixelRatio: 2));
      expect(icon, isA<BytesMapBitmap>());
      final bitmap = icon! as BytesMapBitmap;
      expect(bitmap.imagePixelRatio, 2);
      // PNG signature.
      expect(bitmap.byteData.sublist(0, 4), [137, 80, 78, 71]);
    });

    testWidgets('the painter paints without error', (tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: vanIconLogicalSize,
          height: vanIconLogicalSize,
          child: CustomPaint(painter: VanIconPainter()),
        ),
      ));
      expect(tester.takeException(), isNull);
    });
  });
}
