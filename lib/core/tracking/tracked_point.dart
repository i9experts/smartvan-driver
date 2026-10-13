/// One GPS reading (or a repeat of the last one while the van stands still).
class TrackedPoint {
  const TrackedPoint({
    required this.lat,
    required this.lng,
    required this.time,
    this.speed,
    this.heading,
    this.accuracy,
    this.synthetic = false,
  });

  final double lat;
  final double lng;

  /// When the van was there (not when it was uploaded).
  final DateTime time;

  /// Metres per second; null or negative when the GPS does not know.
  final double? speed;

  /// Degrees; null or negative when unknown.
  final double? heading;

  /// Horizontal accuracy in metres, if the GPS says.
  final double? accuracy;

  /// True for a heartbeat: the last position repeated with speed 0, not a
  /// new reading.
  final bool synthetic;

  /// The last position again, now, standing still.
  TrackedPoint heartbeat(DateTime now) => TrackedPoint(
        lat: lat,
        lng: lng,
        time: now,
        speed: 0,
        heading: heading,
        accuracy: accuracy,
        synthetic: true,
      );

  /// A point of `POST /trips/:id/locations/batch`.
  Map<String, dynamic> toBatchJson() => {
        'lat': lat,
        'lng': lng,
        'time': time.toUtc().toIso8601String(),
        if (speed != null && speed! >= 0) 'speed': speed,
      };

  /// What goes over the app <-> service channel and into storage.
  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lng': lng,
        't': time.millisecondsSinceEpoch,
        if (speed != null) 's': speed,
        if (heading != null) 'h': heading,
        if (accuracy != null) 'a': accuracy,
        if (synthetic) 'x': true,
      };

  static TrackedPoint? fromMap(Object? raw) {
    if (raw is! Map) return null;
    double? num_(String k) => raw[k] is num ? (raw[k] as num).toDouble() : null;
    final lat = num_('lat');
    final lng = num_('lng');
    final t = raw['t'];
    if (lat == null || lng == null || t is! num) return null;
    return TrackedPoint(
      lat: lat,
      lng: lng,
      time: DateTime.fromMillisecondsSinceEpoch(t.toInt()),
      speed: num_('s'),
      heading: num_('h'),
      accuracy: num_('a'),
      synthetic: raw['x'] == true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrackedPoint &&
      other.lat == lat &&
      other.lng == lng &&
      other.time == time &&
      other.speed == speed &&
      other.heading == heading &&
      other.accuracy == accuracy &&
      other.synthetic == synthetic;

  @override
  int get hashCode =>
      Object.hash(lat, lng, time, speed, heading, accuracy, synthetic);

  @override
  String toString() => 'TrackedPoint($lat, $lng, $time, speed: $speed)';
}
