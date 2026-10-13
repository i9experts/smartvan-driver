/// A reading worse than this many metres means the GPS is struggling.
const weakAccuracyMetres = 50.0;

/// A moving van's GPS reports every couple of seconds; this long without any
/// reading means the signal is gone.
const weakAfter = Duration(seconds: 20);

/// Below this speed (m/s) the van counts as standing still.
const stillBelowMetresPerSecond = 1.0;

/// True when the GPS signal looks weak:
///
/// - the last reading's [accuracy] is worse than [weakAccuracyMetres], or
/// - no real reading for [weakAfter] — but only if the van was *moving* at
///   the last one. A van standing still sends no new readings (the GPS only
///   reports after 3 m of movement), and that is not a weak signal.
///
/// With no reading at all yet, [trackingStartedAt] is the reference.
/// Heartbeats (the last position repeated) are not readings.
bool isGpsWeak({
  required DateTime now,
  required DateTime? lastRealFixAt,
  required DateTime? trackingStartedAt,
  double? accuracy,
  double? lastSpeed,
}) {
  if (accuracy != null && accuracy > weakAccuracyMetres) return true;
  if (lastRealFixAt == null) {
    return trackingStartedAt != null &&
        now.difference(trackingStartedAt) >= weakAfter;
  }
  final wasStill = lastSpeed != null && lastSpeed < stillBelowMetresPerSecond;
  if (wasStill) return false;
  return now.difference(lastRealFixAt) >= weakAfter;
}
