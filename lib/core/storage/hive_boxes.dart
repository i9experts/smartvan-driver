/// Names of the app's Hive boxes, and who may open them.
///
/// A Hive box must be opened by **one isolate only** — two isolates writing
/// the same box file corrupt it. The app has two isolates on Android (the UI
/// and the tracking foreground service), so the boxes are split by owner:
///
/// | box               | owner                                              |
/// |-------------------|----------------------------------------------------|
/// | [syncQueue]       | UI isolate (offline pick/drop queue)               |
/// | [session]         | UI isolate (the trip being tracked)                |
/// | [locationBuffer]  | Android: the tracking service only; iOS: the app   |
///
/// On Android the UI never opens [locationBuffer] (it uses the service
/// backend), and the service never opens the other two. `test/core/tracking/
/// hive_ownership_test.dart` checks this.
abstract final class HiveBoxes {
  static const syncQueue = 'sync_queue';
  static const session = 'session';
  static const locationBuffer = 'location_buffer';
}
