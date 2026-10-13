import 'package:hive/hive.dart';
import 'tracked_point.dart';

/// A point waiting to be uploaded, with the key to delete it by.
class BufferedPoint {
  const BufferedPoint(this.key, this.point);

  final int key;
  final TrackedPoint point;
}

/// Points recorded while there was no connection, kept until they could be
/// uploaded (`POST /trips/:id/locations/batch`). Oldest first.
abstract interface class LocationBuffer {
  Future<int> add(String tripId, TrackedPoint point);

  /// Up to [limit] oldest points of [tripId].
  Future<List<BufferedPoint>> next(String tripId, int limit);

  Future<void> remove(Iterable<int> keys);

  Future<int> count(String tripId);

  /// Drops everything of [tripId].
  Future<void> clear(String tripId);
}

/// [LocationBuffer] on a Hive box.
///
/// Hive boxes must only be opened by one isolate. On Android the tracking
/// service's isolate is the only user of this box; on iOS the app itself is.
class HiveLocationBuffer implements LocationBuffer {
  HiveLocationBuffer(this._box, {this.maxPoints = 100000});

  /// Opens (or reuses) the box. Call after `Hive.init...`.
  static Future<HiveLocationBuffer> open(
      {String name = 'location_buffer'}) async {
    final box = Hive.isBoxOpen(name)
        ? Hive.box<Map<dynamic, dynamic>>(name)
        : await Hive.openBox<Map<dynamic, dynamic>>(name);
    return HiveLocationBuffer(box);
  }

  final Box<Map<dynamic, dynamic>> _box;

  /// Beyond this the oldest points are dropped, so a driver who is offline
  /// all day cannot fill the phone.
  final int maxPoints;

  @override
  Future<int> add(String tripId, TrackedPoint point) async {
    if (_box.length >= maxPoints) {
      final overflow = _box.length - maxPoints + 1;
      await _box.deleteAll(_box.keys.take(overflow));
    }
    return _box.add({'trip': tripId, ...point.toMap()});
  }

  @override
  Future<List<BufferedPoint>> next(String tripId, int limit) async {
    final out = <BufferedPoint>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value == null || value['trip'] != tripId) continue;
      final point = TrackedPoint.fromMap(value);
      if (key is! int) continue;
      if (point == null) {
        // Unreadable: it would block the queue for ever.
        await _box.delete(key);
        continue;
      }
      out.add(BufferedPoint(key, point));
      if (out.length >= limit) break;
    }
    return out;
  }

  @override
  Future<void> remove(Iterable<int> keys) => _box.deleteAll(keys);

  @override
  Future<int> count(String tripId) async =>
      _box.values.where((v) => v['trip'] == tripId).length;

  @override
  Future<void> clear(String tripId) async {
    final keys =
        _box.keys.where((k) => _box.get(k)?['trip'] == tripId).toList();
    await _box.deleteAll(keys);
  }
}

/// In memory, for tests.
class MemoryLocationBuffer implements LocationBuffer {
  final Map<int, (String, TrackedPoint)> _items = {};
  int _next = 0;

  @override
  Future<int> add(String tripId, TrackedPoint point) async {
    _items[_next] = (tripId, point);
    return _next++;
  }

  @override
  Future<List<BufferedPoint>> next(String tripId, int limit) async => [
        for (final e in _items.entries)
          if (e.value.$1 == tripId) BufferedPoint(e.key, e.value.$2)
      ].take(limit).toList();

  @override
  Future<void> remove(Iterable<int> keys) async => keys.forEach(_items.remove);

  @override
  Future<int> count(String tripId) async =>
      _items.values.where((v) => v.$1 == tripId).length;

  @override
  Future<void> clear(String tripId) async =>
      _items.removeWhere((_, v) => v.$1 == tripId);
}
