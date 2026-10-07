import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/active_trip.dart';

/// Remembers the trip that is currently being tracked, so tracking can be
/// resumed if Android/iOS kills the app mid-trip.
abstract interface class ActiveTripStore {
  ActiveTrip? read();
  Future<void> save(ActiveTrip trip);
  Future<void> clear();
}

/// [ActiveTripStore] on a Hive box. Call [init] once at start-up.
class HiveActiveTripStore implements ActiveTripStore {
  HiveActiveTripStore({String boxName = 'session'}) : _boxName = boxName;

  static const _key = 'active_trip';
  final String _boxName;

  Box? get _box => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : null;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) await Hive.openBox(_boxName);
  }

  @override
  Future<void> save(ActiveTrip trip) async {
    try {
      await _box?.put(_key, jsonEncode(trip.toJson()));
    } catch (e) {
      debugPrint('[ActiveTripStore] could not save trip: $e');
    }
  }

  @override
  ActiveTrip? read() {
    final raw = _box?.get(_key);
    if (raw is! String) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final trip = ActiveTrip.fromJson(Map<String, dynamic>.from(decoded));
      return trip.id.isEmpty ? null : trip;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clear() async => _box?.delete(_key);
}

final activeTripStoreProvider =
    Provider<ActiveTripStore>((ref) => HiveActiveTripStore());
