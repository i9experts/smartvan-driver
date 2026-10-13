import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/map/polyline_codec.dart';
import '../../../../core/map/stop_marker_icon.dart';
import '../../data/models/route_plan.dart';
import '../../data/models/stop_status.dart';

const planLineColor = Color(0xFF2F80ED);
const trailLineColor = Color(0xFF1B3B69);

/// Pin colour for a stop's state (absent / no-show are red and crossed out).
Color stopColor(StopStatus status) => switch (status) {
      StopStatus.waiting => const Color(0xFFFEC610),
      StopStatus.picked => const Color(0xFF27AE60),
      StopStatus.dropped => const Color(0xFF9AA3B2),
      StopStatus.absent || StopStatus.noShow => const Color(0xFFEB5757),
      StopStatus.unknown => const Color(0xFF9AA3B2),
    };

/// The style of the pin for [stop]; [nextStopOrder] is highlighted.
StopMarkerStyle stopStyle(RoutePlanStop stop, int? nextStopOrder) =>
    StopMarkerStyle(
      number: stop.order,
      color: stopColor(stop.status),
      crossedOut:
          stop.status == StopStatus.absent || stop.status == StopStatus.noShow,
      highlighted: nextStopOrder != null && stop.order == nextStopOrder,
    );

/// Every distinct pin look in [plan] — what the screen has to prepare icons
/// for.
Set<StopMarkerStyle> stopStylesOf(RoutePlan plan) =>
    {for (final s in plan.drawableStops) stopStyle(s, plan.nextStopOrder)};

/// Numbered stop markers plus the school. A stop whose icon is not ready
/// yet gets the default pin.
Set<Marker> planMarkers(
  RoutePlan plan, {
  required Map<StopMarkerStyle, BitmapDescriptor> icons,
  required String schoolTitle,
}) {
  final markers = <Marker>{};
  for (final stop in plan.drawableStops) {
    final style = stopStyle(stop, plan.nextStopOrder);
    markers.add(Marker(
      markerId: MarkerId('stop-${stop.order}-${stop.kidId ?? ''}'),
      position: LatLng(stop.lat!, stop.lng!),
      icon: icons[style] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      anchor: const Offset(0.5, 0.5),
      zIndex: style.highlighted ? 0.8 : 0.5,
      infoWindow: InfoWindow(title: '${stop.order}. ${stop.fullname ?? ''}'),
    ));
  }
  final school = plan.school;
  if (school?.lat != null && school?.lng != null) {
    markers.add(Marker(
      markerId: const MarkerId('school'),
      position: LatLng(school!.lat!, school.lng!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      zIndex: 0.6,
      infoWindow: InfoWindow(title: school.name ?? schoolTitle),
    ));
  }
  return markers;
}

/// The blue planned road ahead, and the navy path already driven on top.
Set<Polyline> mapLines({RoutePlan? plan, List<LatLng> trail = const []}) {
  final planned = decodePolyline(plan?.plannedPath?.polyline);
  return {
    if (planned.length > 1)
      Polyline(
        polylineId: const PolylineId('planned'),
        points: planned,
        color: planLineColor,
        width: 5,
        zIndex: 1,
      ),
    if (trail.length > 1)
      Polyline(
        polylineId: const PolylineId('trail'),
        points: trail,
        color: trailLineColor,
        width: 5,
        zIndex: 2,
      ),
  };
}
