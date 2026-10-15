import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/map/stop_marker_icon.dart';
import '../../../trip/data/models/stop_status.dart';
import '../../../trip/presentation/widgets/trip_map_layers.dart';
import '../../application/history_map_data.dart';
import '../../data/models/trip_details.dart';

/// A stop's pin: green once a student was picked, grey once dropped, red and
/// crossed out when every student was absent / a no-show, yellow otherwise.
StopMarkerStyle historyStopStyle(TripStop stop) {
  final outcomes = {for (final s in stop.students) s.status};
  final StopStatus status;
  if (outcomes.contains(StudentOutcome.picked)) {
    status = StopStatus.picked;
  } else if (outcomes.contains(StudentOutcome.dropped)) {
    status = StopStatus.dropped;
  } else if (outcomes.isNotEmpty &&
      outcomes.every(
          (o) => o == StudentOutcome.absent || o == StudentOutcome.noShow)) {
    status = StopStatus.absent;
  } else {
    status = StopStatus.waiting;
  }
  return StopMarkerStyle(
    number: stop.order,
    color: stopColor(status),
    crossedOut: status == StopStatus.absent,
  );
}

/// Every distinct stop pin look in [details].
Set<StopMarkerStyle> historyStopStyles(TripDetails details) =>
    {for (final s in drawableStops(details)) historyStopStyle(s)};

/// Start, end, numbered stops and school.
Set<Marker> historyMarkers(
  TripDetails details, {
  required LatLng? start,
  required LatLng? end,
  required Map<StopMarkerStyle, BitmapDescriptor> icons,
  required String startTitle,
  required String endTitle,
  required String schoolTitle,
}) {
  final markers = <Marker>{};
  for (final stop in drawableStops(details)) {
    final style = historyStopStyle(stop);
    markers.add(Marker(
      markerId: MarkerId('stop-${stop.order}'),
      position: LatLng(stop.lat!, stop.lng!),
      icon: icons[style] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      anchor: const Offset(0.5, 0.5),
      zIndex: 0.5,
      infoWindow: InfoWindow(title: '${stop.order}. ${stop.placeName ?? ''}'),
    ));
  }
  final school = schoolPosition(details);
  if (school != null) {
    markers.add(Marker(
      markerId: const MarkerId('school'),
      position: school,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      zIndex: 0.6,
      infoWindow: InfoWindow(title: details.school?.name ?? schoolTitle),
    ));
  }
  if (start != null) {
    markers.add(Marker(
      markerId: const MarkerId('start'),
      position: start,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      zIndex: 0.9,
      infoWindow: InfoWindow(title: startTitle),
    ));
  }
  if (end != null) {
    markers.add(Marker(
      markerId: const MarkerId('end'),
      position: end,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      zIndex: 1,
      infoWindow: InfoWindow(title: endTitle),
    ));
  }
  return markers;
}

/// The saved driven path.
Set<Polyline> historyPolylines(List<LatLng> points) => {
      if (points.length > 1)
        Polyline(
          polylineId: const PolylineId('trail'),
          points: points,
          color: trailLineColor,
          width: 5,
          zIndex: 2,
        ),
    };
