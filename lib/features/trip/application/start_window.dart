/// The backend only lets a trip start within one hour of its scheduled time
/// (same time-of-day as the route's `startTime`, today). Mirrored here so the
/// driver sees *why* "Start Trip" is unavailable.
bool isWithinStartWindow(DateTime? scheduledStart, DateTime now) {
  if (scheduledStart == null) return true;
  final local = scheduledStart.toLocal();
  final scheduledToday =
      DateTime(now.year, now.month, now.day, local.hour, local.minute);
  final windowEnd = scheduledToday.add(const Duration(hours: 1));
  return !now.isBefore(scheduledToday) && !now.isAfter(windowEnd);
}
