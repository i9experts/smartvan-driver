import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartvan_driver/features/trip/application/battery_guard.dart';

class FakePlatform implements BatteryPlatform {
  FakePlatform({
    this.supported = true,
    this.exempt = false,
    this.maker = 'samsung',
    this.screens = const {},
  });

  @override
  bool supported;
  bool exempt;
  String maker;

  /// "package/activity" strings this phone can open.
  Set<String> screens;

  int exemptionRequests = 0;
  final opened = <String>[];
  int appSettingsOpened = 0;

  @override
  Future<bool> isExempt() async => exempt;

  @override
  Future<bool> requestExemption() async {
    exemptionRequests++;
    return true;
  }

  @override
  Future<String> manufacturer() async => maker;

  @override
  Future<bool> open(SettingsScreen screen) async {
    final key = '${screen.package}/${screen.activity}';
    opened.add(key);
    return screens.contains(key);
  }

  @override
  Future<void> openApp() async => appSettingsOpened++;
}

void main() {
  late FakePlatform platform;
  late BatteryGuard guard;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    platform = FakePlatform();
    guard = BatteryGuard(platform, SharedPreferences.getInstance);
  });

  group('oemGuideFor', () {
    test('the makers that stop background apps', () {
      for (final (maker, brand) in [
        ('Xiaomi', 'Xiaomi'),
        ('Redmi', 'Xiaomi'),
        ('POCO', 'Xiaomi'),
        ('OPPO', 'Oppo'),
        ('realme', 'Realme'),
        ('vivo', 'Vivo'),
        ('iQOO', 'Vivo'),
        ('HUAWEI', 'Huawei'),
        ('HONOR', 'Honor'),
      ]) {
        expect(oemGuideFor(maker)?.brand, brand, reason: maker);
        expect(oemGuideFor(maker)!.screens, isNotEmpty, reason: maker);
      }
    });

    test('others need none', () {
      for (final maker in ['samsung', 'Google', 'motorola', '']) {
        expect(oemGuideFor(maker), isNull, reason: maker);
      }
    });
  });

  group('run', () {
    test('asks for the battery exemption the first time only', () async {
      await guard.run();
      expect(platform.exemptionRequests, 1);
      await guard.run();
      expect(platform.exemptionRequests, 1);
    });

    test('does not ask when the app is already exempt', () async {
      platform.exempt = true;
      await guard.run();
      expect(platform.exemptionRequests, 0);
    });

    test('a new guard on the same phone remembers (app restarted)', () async {
      await guard.run();
      final again = BatteryGuard(platform, SharedPreferences.getInstance);
      await again.run();
      expect(platform.exemptionRequests, 1);
    });

    test('a Xiaomi phone gets the guide once', () async {
      platform.maker = 'Xiaomi';
      final first = await guard.run();
      expect(first?.brand, 'Xiaomi');
      expect(await guard.run(), isNull);
    });

    test('a Samsung phone gets no guide', () async {
      expect(await guard.run(), isNull);
    });

    test('nothing at all where the settings do not exist (iOS)', () async {
      platform.supported = false;
      platform.maker = 'Xiaomi';
      expect(await guard.run(), isNull);
      expect(platform.exemptionRequests, 0);
    });
  });

  group('openSettingsFor', () {
    test('opens the first screen this phone has', () async {
      final guide = oemGuideFor('oppo')!;
      final second = guide.screens[1];
      platform.screens = {'${second.package}/${second.activity}'};
      await guard.openSettingsFor(guide);
      expect(platform.opened, hasLength(2), reason: 'first one missing');
      expect(platform.appSettingsOpened, 0);
    });

    test('falls back to the app\'s own settings', () async {
      await guard.openSettingsFor(oemGuideFor('vivo')!);
      expect(platform.opened, hasLength(2));
      expect(platform.appSettingsOpened, 1);
    });
  });
}
