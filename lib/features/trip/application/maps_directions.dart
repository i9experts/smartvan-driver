import '../data/models/optimized_route.dart';

/// Google Maps links take at most 9 waypoints plus the destination.
const googleMapsMaxPoints = 10;

/// The points a Google Maps link has to pass: the stops that have a position
/// (in the suggested order), then the route's destination. The destination is
/// left out when it is the last stop itself (a drop trip ends at a stop).
List<({double lat, double lng})> _points(OptimizedRoute route) {
  final stops = [
    for (final s in route.stops)
      if (s.lat != null && s.lng != null) (lat: s.lat!, lng: s.lng!),
  ];
  final d = route.destination!;
  final endsAtLastStop =
      stops.isNotEmpty && stops.last.lat == d.lat && stops.last.lng == d.lng;
  return [...stops, if (!endsAtLastStop) (lat: d.lat, lng: d.lng)];
}

/// The Google Maps link that navigates [route]: from its origin through the
/// stops in the suggested order to its destination. Null when the route has
/// no origin or destination. Stops without coordinates are left out. When
/// there are more stops than Google Maps accepts, the link covers the next
/// [googleMapsMaxPoints] points only (see [googleMapsLinkIsPartial]).
Uri? googleMapsDirectionsUri(OptimizedRoute route) {
  final origin = route.origin;
  if (origin == null || route.destination == null) return null;

  final points = _points(route).take(googleMapsMaxPoints).toList();
  final destination = points.last;
  final waypoints = [
    for (final p in points.take(points.length - 1)) '${p.lat},${p.lng}',
  ];
  final waypointsParam =
      waypoints.isEmpty ? '' : '&waypoints=${waypoints.join('|')}';

  return Uri.parse('https://www.google.com/maps/dir/?api=1'
      '&origin=${origin.lat},${origin.lng}'
      '&destination=${destination.lat},${destination.lng}'
      '$waypointsParam'
      '&travelmode=driving');
}

/// The route has more points than one Google Maps link can hold.
bool googleMapsLinkIsPartial(OptimizedRoute route) =>
    route.destination != null && _points(route).length > googleMapsMaxPoints;
