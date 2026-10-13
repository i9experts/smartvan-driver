import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/map/polyline_codec.dart';

void main() {
  test('decodes the documented Google example', () {
    final points = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    expect(points, hasLength(3));
    expect(points[0].latitude, closeTo(38.5, 1e-9));
    expect(points[0].longitude, closeTo(-120.2, 1e-9));
    expect(points[1].latitude, closeTo(40.7, 1e-9));
    expect(points[1].longitude, closeTo(-120.95, 1e-9));
    expect(points[2].latitude, closeTo(43.252, 1e-9));
    expect(points[2].longitude, closeTo(-126.453, 1e-9));
  });

  test('null and empty give no points', () {
    expect(decodePolyline(null), isEmpty);
    expect(decodePolyline(''), isEmpty);
  });

  test('a truncated string keeps the whole points read so far', () {
    final points = decodePolyline('_p~iF~ps|U_ulLnnq');
    expect(points, hasLength(1));
  });
}
