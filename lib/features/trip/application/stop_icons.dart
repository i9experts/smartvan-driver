import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/map/stop_marker_icon.dart';

/// Makes stop pins; overridden in tests.
final stopIconFactoryProvider =
    Provider<StopIconFactory>((ref) => createStopIcon);

/// The pin for [key] (style + device pixel ratio), made once and kept.
final stopIconProvider = FutureProvider.family<BitmapDescriptor,
    ({StopMarkerStyle style, double ratio})>(
  (ref, key) => ref.watch(stopIconFactoryProvider)(key.style,
      devicePixelRatio: key.ratio),
);
