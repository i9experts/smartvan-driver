import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// iOS: location set to "Always". With "While Using" the location background
/// mode still keeps tracking alive while the app is in the background, but
/// iOS can end it sooner and shows the blue "using your location" pill;
/// "Always" is the setting meant for a trip that runs with the screen off.
///
/// (Android needs nothing here: its foreground service tracks with the
/// permission the app already has.)
abstract interface class AlwaysLocation {
  /// Only iOS has this question.
  bool get applies;

  Future<bool> isGranted();

  /// Asks the system for "Always" — at most once per install (iOS shows its
  /// own prompt only once anyway). True if granted.
  Future<bool> askOnce();
}

class IosAlwaysLocation implements AlwaysLocation {
  IosAlwaysLocation(this._prefs);

  static const askedKey = 'ios_always_location_asked';

  final Future<SharedPreferences> Function() _prefs;

  @override
  bool get applies => !kIsWeb && Platform.isIOS;

  @override
  Future<bool> isGranted() => Permission.locationAlways.isGranted;

  @override
  Future<bool> askOnce() async {
    final prefs = await _prefs();
    if (prefs.getBool(askedKey) == true) return false;
    await prefs.setBool(askedKey, true);
    return (await Permission.locationAlways.request()).isGranted;
  }
}

final alwaysLocationProvider = Provider<AlwaysLocation>(
    (ref) => IosAlwaysLocation(SharedPreferences.getInstance));
