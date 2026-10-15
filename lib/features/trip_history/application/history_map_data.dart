import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/map/polyline_codec.dart';
import '../../trip/data/models/trip_trail.dart';
import '../data/models/trip_details.dart';

/// The driven path: the simplified `path`, or the encoded `polyline` of an
/// older trail. Empty when the trip has no saved route.
List<LatLng> trailPoints(TripTrail trail) => trail.path.isNotEmpty
    ? [for (final p in trail.path) LatLng(p.lat, p.lng)]
    : decodePolyline(trail.polyline);

/// Where the trip began: the trail's `start`, else its first point.
LatLng? trailStart(TripTrail trail, List<LatLng> points) {
  final s = trail.start;
  if (s != null) return LatLng(s.lat, s.lng);
  return points.isEmpty ? null : points.first;
}

/// Where the trip ended: the trail's `end`, else its last point.
LatLng? trailEnd(TripTrail trail, List<LatLng> points) {
  final e = trail.end;
  if (e != null) return LatLng(e.lat, e.lng);
  return points.isEmpty ? null : points.last;
}

/// The stops that have a position, in order.
List<TripStop> drawableStops(TripDetails details) => [
      for (final s in details.stops)
        if (s.lat != null && s.lng != null && (s.lat != 0 || s.lng != 0)) s,
    ];

/// The school's position, or null when it has none saved.
LatLng? schoolPosition(TripDetails details) {
  final s = details.school;
  if (s?.lat == null || s?.lng == null) return null;
  return LatLng(s!.lat!, s.lng!);
}

/// Smallest box around [points]; null for none.
LatLngBounds? boundsOf(Iterable<LatLng> points) {
  double? minLat, maxLat, minLng, maxLng;
  for (final p in points) {
    minLat = minLat == null || p.latitude < minLat ? p.latitude : minLat;
    maxLat = maxLat == null || p.latitude > maxLat ? p.latitude : maxLat;
    minLng = minLng == null || p.longitude < minLng ? p.longitude : minLng;
    maxLng = maxLng == null || p.longitude > maxLng ? p.longitude : maxLng;
  }
  if (minLat == null) return null;
  return LatLngBounds(
      southwest: LatLng(minLat, minLng!), northeast: LatLng(maxLat!, maxLng!));
}
