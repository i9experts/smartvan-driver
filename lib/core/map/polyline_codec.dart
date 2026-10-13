import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Decodes a Google encoded polyline (precision 5) into points. A malformed
/// or empty string gives the points read so far (possibly none).
List<LatLng> decodePolyline(String? encoded) {
  final points = <LatLng>[];
  if (encoded == null || encoded.isEmpty) return points;
  var index = 0;
  var lat = 0;
  var lng = 0;

  int? readValue() {
    var result = 0;
    var shift = 0;
    while (true) {
      if (index >= encoded.length) return null;
      final b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
      if (b < 0x20) break;
    }
    return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
  }

  while (index < encoded.length) {
    final dLat = readValue();
    final dLng = readValue();
    if (dLat == null || dLng == null) break;
    lat += dLat;
    lng += dLng;
    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}
