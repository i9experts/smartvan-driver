import '../data/models/optimized_route.dart';

/// The Google Maps link that navigates [route]: from its origin to its
/// destination through the stops in the suggested order. Null when the route
/// has no origin or destination. Stops without coordinates are left out.
Uri? googleMapsDirectionsUri(OptimizedRoute route) {
  final origin = route.origin;
  final destination = route.destination;
  if (origin == null || destination == null) return null;

  final waypoints = [
    for (final s in route.stops)
      if (s.lat != null && s.lng != null) '${s.lat},${s.lng}',
  ];
  final waypointsParam =
      waypoints.isEmpty ? '' : '&waypoints=${waypoints.join('|')}';

  return Uri.parse('https://www.google.com/maps/dir/?api=1'
      '&origin=${origin.lat},${origin.lng}'
      '&destination=${destination.lat},${destination.lng}'
      '$waypointsParam'
      '&travelmode=driving');
}
