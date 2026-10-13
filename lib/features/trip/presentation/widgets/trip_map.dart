import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds the live map. A provider so tests can swap the platform map for a
/// stand-in.
typedef TripMapBuilder = Widget Function(
  BuildContext context, {
  required LatLng target,
  required Set<Marker> markers,
  required Set<Polyline> polylines,
  required void Function(GoogleMapController controller) onCreated,
  required void Function(CameraPosition position) onCameraMove,
});

final tripMapBuilderProvider = Provider<TripMapBuilder>(
  (ref) => (context,
          {required target,
          required markers,
          required polylines,
          required onCreated,
          required onCameraMove}) =>
      GoogleMap(
        initialCameraPosition: CameraPosition(target: target, zoom: 14),
        onMapCreated: onCreated,
        onCameraMove: onCameraMove,
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        // Our own compass button replaces Google's; the driver can turn the
        // map with two fingers, but it never tilts.
        compassEnabled: false,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: false,
      ),
);
