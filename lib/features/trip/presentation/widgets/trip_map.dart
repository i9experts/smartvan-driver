import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds the live map. A provider so tests can swap the platform map for a
/// stand-in.
typedef TripMapBuilder = Widget Function(
  BuildContext context, {
  required LatLng target,
  required Set<Marker> markers,
  required void Function(GoogleMapController controller) onCreated,
});

final tripMapBuilderProvider = Provider<TripMapBuilder>(
  (ref) => (context, {required target, required markers, required onCreated}) =>
      GoogleMap(
        initialCameraPosition: CameraPosition(target: target, zoom: 14),
        onMapCreated: onCreated,
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
);
