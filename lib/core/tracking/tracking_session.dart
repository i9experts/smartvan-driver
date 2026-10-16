import 'dart:math';

/// Who is tracking a trip: one per start/resume on a phone. The server keeps
/// only the newest session for a trip, so a second phone logged in as the
/// same driver cannot mix its position into the trail — it is told to stop.
class TrackingSession {
  const TrackingSession({
    required this.sessionId,
    required this.deviceId,
    this.claimed = false,
  });

  /// New random id per start; [deviceId] stays the same for this phone.
  factory TrackingSession.create(String deviceId, {Random? random}) =>
      TrackingSession(sessionId: randomId(random: random), deviceId: deviceId);

  final String sessionId;
  final String deviceId;

  /// The server knows this session (POST /trips/:id/tracking-session
  /// succeeded). Until then this phone must not send points with its id.
  final bool claimed;

  TrackingSession get asClaimed =>
      TrackingSession(sessionId: sessionId, deviceId: deviceId, claimed: true);

  /// The ids every location request carries.
  Map<String, String> get fields =>
      {'sessionId': sessionId, 'deviceId': deviceId};

  @override
  bool operator ==(Object other) =>
      other is TrackingSession &&
      other.sessionId == sessionId &&
      other.deviceId == deviceId &&
      other.claimed == claimed;

  @override
  int get hashCode => Object.hash(sessionId, deviceId, claimed);

  @override
  String toString() => 'TrackingSession($sessionId, device $deviceId, claimed: $claimed)';
}

/// 16 random bytes as hex.
String randomId({Random? random}) {
  final r = random ?? Random.secure();
  return [for (var i = 0; i < 16; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')]
      .join();
}
