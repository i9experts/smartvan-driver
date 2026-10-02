import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Remembers the trip that is currently being tracked, so tracking can be
/// resumed if Android/iOS kills the app mid-trip.
class ActiveTripStore {
  ActiveTripStore._();

  static const _boxName = 'session';
  static const _key = 'active_trip';
  static Box? _box;

  static Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  static Future<void> save(Map<String, dynamic> trip) async {
    try {
      await _box?.put(_key, jsonEncode(trip));
    } catch (e) {
      debugPrint('[ActiveTripStore] could not save trip: $e');
    }
  }

  static Map<String, dynamic>? read() {
    final raw = _box?.get(_key);
    if (raw is! String) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async => _box?.delete(_key);
}
