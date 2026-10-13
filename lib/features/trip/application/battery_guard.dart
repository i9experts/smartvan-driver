import 'dart:io' show Platform;
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A vendor settings screen that can be opened directly.
class SettingsScreen {
  const SettingsScreen(this.package, this.activity);

  final String package;
  final String activity;
}

/// What to tell the driver on a phone whose maker stops background apps on
/// its own (Xiaomi, Oppo, Vivo, Realme, Huawei and friends).
class OemGuide {
  const OemGuide(this.brand, this.screens);

  final String brand;

  /// Tried in order; the first one this phone has is opened.
  final List<SettingsScreen> screens;
}

/// The guide for [manufacturer] (as `Build.MANUFACTURER` says it), or null
/// when that maker needs none.
OemGuide? oemGuideFor(String manufacturer) {
  final m = manufacturer.toLowerCase();
  bool any(List<String> names) => names.any(m.contains);

  if (any(['xiaomi', 'redmi', 'poco'])) {
    return const OemGuide('Xiaomi', [
      SettingsScreen('com.miui.securitycenter',
          'com.miui.permcenter.autostart.AutoStartManagementActivity'),
    ]);
  }
  if (any(['oppo', 'realme', 'oneplus'])) {
    return OemGuide(m.contains('realme') ? 'Realme' : 'Oppo', const [
      SettingsScreen('com.coloros.safecenter',
          'com.coloros.safecenter.permission.startup.StartupAppListActivity'),
      SettingsScreen('com.oppo.safe',
          'com.oppo.safe.permission.startup.StartupAppListActivity'),
      SettingsScreen('com.coloros.safecenter',
          'com.coloros.safecenter.startupapp.StartupAppListActivity'),
    ]);
  }
  if (any(['vivo', 'iqoo'])) {
    return const OemGuide('Vivo', [
      SettingsScreen('com.vivo.permissionmanager',
          'com.vivo.permissionmanager.activity.BgStartUpManagerActivity'),
      SettingsScreen('com.iqoo.secure',
          'com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity'),
    ]);
  }
  if (any(['huawei', 'honor'])) {
    return OemGuide(m.contains('honor') ? 'Honor' : 'Huawei', const [
      SettingsScreen('com.huawei.systemmanager',
          'com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity'),
      SettingsScreen('com.huawei.systemmanager',
          'com.huawei.systemmanager.optimize.process.ProtectActivity'),
    ]);
  }
  return null;
}

/// The phone-level calls [BatteryGuard] needs; a seam for tests.
abstract interface class BatteryPlatform {
  /// Only Android has these settings.
  bool get supported;

  Future<bool> isExempt();

  /// Shows the system "allow SmartVan to run without battery restrictions"
  /// dialog; true if allowed.
  Future<bool> requestExemption();

  Future<String> manufacturer();

  /// Opens [screen]; false if this phone has no such screen.
  Future<bool> open(SettingsScreen screen);

  /// The app's own page in system settings.
  Future<void> openApp();
}

class AndroidBatteryPlatform implements BatteryPlatform {
  @override
  bool get supported => !kIsWeb && Platform.isAndroid;

  @override
  Future<bool> isExempt() => Permission.ignoreBatteryOptimizations.isGranted;

  @override
  Future<bool> requestExemption() async =>
      (await Permission.ignoreBatteryOptimizations.request()).isGranted;

  @override
  Future<String> manufacturer() async =>
      (await DeviceInfoPlugin().androidInfo).manufacturer;

  @override
  Future<bool> open(SettingsScreen screen) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: screen.package,
        componentName: screen.activity,
      );
      if (await intent.canResolveActivity() != true) return false;
      await intent.launch();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> openApp() async {
    await openAppSettings();
  }
}

/// Asks, once per phone, for what keeps trip tracking alive on Android.
///
/// 1. The battery-optimization exemption (a system dialog).
/// 2. On phones of makers that kill background apps (Xiaomi, Oppo, Vivo,
///    Realme, Huawei), a one-time guide to the autostart / background screen.
///
/// Both are remembered, so the driver is not asked again.
class BatteryGuard {
  BatteryGuard(this._platform, this._prefs);

  static const exemptionAskedKey = 'battery_exemption_asked';
  static const guideShownKey = 'oem_guide_shown';

  final BatteryPlatform _platform;
  final Future<SharedPreferences> Function() _prefs;

  /// Run at trip start. Shows the system battery dialog the first time, and
  /// returns the maker's guide if it has not been shown yet (and marks it as
  /// shown) — the caller displays it. Null when there is nothing to show.
  Future<OemGuide?> run() async {
    if (!_platform.supported) return null;
    final prefs = await _prefs();

    if (prefs.getBool(exemptionAskedKey) != true) {
      await prefs.setBool(exemptionAskedKey, true);
      try {
        if (!await _platform.isExempt()) await _platform.requestExemption();
      } catch (e) {
        debugPrint('[Battery] exemption request failed: $e');
      }
    }

    if (prefs.getBool(guideShownKey) == true) return null;
    final guide = oemGuideFor(await _platform.manufacturer());
    if (guide == null) return null;
    await prefs.setBool(guideShownKey, true);
    return guide;
  }

  /// Opens the maker's screen; the app's own settings if this phone has none
  /// of them.
  Future<void> openSettingsFor(OemGuide guide) async {
    for (final screen in guide.screens) {
      if (await _platform.open(screen)) return;
    }
    await _platform.openApp();
  }
}

final batteryGuardProvider = Provider<BatteryGuard>((ref) =>
    BatteryGuard(AndroidBatteryPlatform(), SharedPreferences.getInstance));
