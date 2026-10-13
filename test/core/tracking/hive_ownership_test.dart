import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/storage/hive_boxes.dart';

/// A Hive box may be opened by one isolate only. On Android the tracking
/// service runs in its own isolate, so it must have a box of its own and must
/// not touch the app's boxes (and the app must not touch the service's).
void main() {
  List<File> dartFiles(String dir) => Directory(dir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  String rel(File f) => f.path.replaceAll('\\', '/');

  test('every box has its own name', () {
    final names = [
      HiveBoxes.syncQueue,
      HiveBoxes.session,
      HiveBoxes.locationBuffer,
    ];
    expect(names.toSet(), hasLength(names.length));
  });

  test('the service isolate opens only the location buffer', () {
    final service = File('lib/features/trip/background/tracking_service.dart')
        .readAsStringSync();
    // Boxes it may use: through HiveLocationBuffer only.
    expect(service, contains('HiveLocationBuffer.open()'));
    for (final forbidden in [
      'HiveActiveTripStore',
      'activeTripStore',
      'SyncQueue',
      'syncQueue',
      'openBox',
      'HiveBoxes.session',
      'HiveBoxes.syncQueue',
    ]) {
      expect(service, isNot(contains(forbidden)),
          reason: 'the service must not touch $forbidden');
    }
  });

  test('everything the service imports from the app stays Hive-free', () {
    // The service pulls in only core network/config/tracking code; none of it
    // may open the app\'s boxes.
    final service = File('lib/features/trip/background/tracking_service.dart')
        .readAsStringSync();
    final imports = RegExp(r"import '(\.\./[^']+)';")
        .allMatches(service)
        .map((m) => m.group(1)!)
        .toList();
    final base = Directory('lib/features/trip/background/').absolute.uri;
    var checked = 0;
    for (final path in imports) {
      final file = File.fromUri(base.resolve(path));
      expect(file.existsSync(), isTrue, reason: path);
      checked++;
      final text = file.readAsStringSync();
      expect(text, isNot(contains('HiveBoxes.session')),
          reason: '$path opens the session box');
      expect(text, isNot(contains('HiveBoxes.syncQueue')),
          reason: '$path opens the sync queue box');
    }
    expect(checked, greaterThan(5));
  });

  test(
      'the app (UI isolate) opens the location buffer only through the iOS '
      'backend', () {
    final users = dartFiles('lib')
        .where((f) => f.readAsStringSync().contains('HiveLocationBuffer.open'))
        .map(rel)
        .toList()
      ..sort();
    expect(users, [
      'lib/features/trip/application/tracking_backend.dart',
      'lib/features/trip/background/tracking_service.dart',
    ]);

    // …and the provider there builds that opener only for the non-Android
    // backend, never next to the Android service one.
    final provider = File('lib/features/trip/application/tracking_backend.dart')
        .readAsStringSync();
    final androidBranch = provider.substring(
        provider.indexOf('Platform.isAndroid'),
        provider.indexOf('final backend = InAppTrackingBackend('));
    expect(androidBranch, isNot(contains('HiveLocationBuffer')));
    expect(androidBranch, contains('ServiceTrackingBackend()'));
  });

  test('only bootstrap opens the app boxes, and not from the service', () {
    final openers = dartFiles('lib')
        .where((f) {
          final t = f.readAsStringSync();
          return t.contains('Hive.openBox') &&
              !rel(f).contains('/core/tracking/');
        })
        .map(rel)
        .toList()
      ..sort();
    expect(openers, [
      'lib/core/sync/sync_queue.dart',
      'lib/features/trip/data/active_trip_store.dart',
    ]);
  });
}
