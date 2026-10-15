import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/map/stop_marker_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/application/stop_icons.dart';
import '../../../trip/data/models/trip_trail.dart';
import '../../application/history_map_data.dart';
import '../../data/models/trip_details.dart';
import 'history_map_layers.dart';

/// Builds the static history map. A provider so tests can swap the platform
/// map for a stand-in.
typedef HistoryMapBuilder = Widget Function(
  BuildContext context, {
  required LatLng target,
  required Set<Marker> markers,
  required Set<Polyline> polylines,
  required void Function(GoogleMapController controller) onCreated,
});

/// Where the map starts when a trip has nothing to draw (Karachi).
const _fallbackTarget = LatLng(24.8607, 67.0011);

final historyMapBuilderProvider = Provider<HistoryMapBuilder>(
  (ref) => (context,
          {required target,
          required markers,
          required polylines,
          required onCreated}) =>
      GoogleMap(
        initialCameraPosition: CameraPosition(target: target, zoom: 13),
        onMapCreated: onCreated,
        markers: markers,
        polylines: polylines,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        // A history map is north-up and flat: no compass, no rotate, no tilt.
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
      ),
);

/// The finished trip on a map: driven path, start / end, numbered stops and
/// the school, fitted into view. Nothing here is live.
class HistoryRouteMap extends ConsumerStatefulWidget {
  const HistoryRouteMap(
      {super.key, required this.details, required this.trail});

  final TripDetails details;
  final TripTrail trail;

  @override
  ConsumerState<HistoryRouteMap> createState() => _HistoryRouteMapState();
}

class _HistoryRouteMapState extends ConsumerState<HistoryRouteMap> {
  static const _fitPadding = 56.0;

  GoogleMapController? _controller;

  List<LatLng> get _path => trailPoints(widget.trail);

  /// Everything that should be visible at once.
  List<LatLng> get _visiblePoints {
    final school = schoolPosition(widget.details);
    return [
      ..._path,
      for (final s in drawableStops(widget.details)) LatLng(s.lat!, s.lng!),
      if (school != null) school,
    ];
  }

  @override
  void didUpdateWidget(HistoryRouteMap old) {
    super.didUpdateWidget(old);
    if (old.trail != widget.trail || old.details != widget.details) _fit();
  }

  Future<void> _fit() async {
    final controller = _controller;
    final bounds = boundsOf(_visiblePoints);
    if (controller == null || bounds == null) return;
    final single = bounds.southwest == bounds.northeast;
    try {
      await controller.moveCamera(single
          ? CameraUpdate.newLatLngZoom(bounds.southwest, 16)
          : CameraUpdate.newLatLngBounds(bounds, _fitPadding));
    } catch (_) {
      // The map was not laid out yet; the initial camera stays.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = widget.details;
    final path = _path;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final icons = <StopMarkerStyle, BitmapDescriptor>{
      for (final style in historyStopStyles(details))
        if (ref
                .watch(stopIconProvider((style: style, ratio: ratio)))
                .valueOrNull
            case final icon?)
          style: icon,
    };
    final markers = historyMarkers(
      details,
      start: trailStart(widget.trail, path),
      end: trailEnd(widget.trail, path),
      icons: icons,
      startTitle: l10n.tripDetailsMarkerStart,
      endTitle: l10n.tripDetailsMarkerEnd,
      schoolTitle: l10n.tripMapSchool,
    );
    final visible = _visiblePoints;
    return Stack(
      children: [
        Positioned.fill(
          child: ref.watch(historyMapBuilderProvider)(
            context,
            target: visible.isEmpty ? _fallbackTarget : visible.first,
            markers: markers,
            polylines: historyPolylines(path),
            onCreated: (c) {
              _controller = c;
              _fit();
            },
          ),
        ),
        if (path.length < 2)
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Center(
              child: Container(
                key: const Key('route-unavailable'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: Text(l10n.tripDetailsRouteUnavailable,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textDark)),
              ),
            ),
          ),
      ],
    );
  }
}
