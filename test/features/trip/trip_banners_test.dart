import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/trip_banners.dart';

import '../../support/l10n_host.dart';

void main() {
  Widget banners({
    bool isTracking = true,
    bool gpsWeak = false,
    bool always = false,
    VoidCallback? onOpenSettings,
  }) =>
      l10nHost(TripBanners(
        isTracking: isTracking,
        pending: 0,
        onTurnOn: () {},
        gpsWeak: gpsWeak,
        needsAlwaysLocation: always,
        onOpenSettings: onOpenSettings,
      ));

  const weak = "GPS signal is weak — the van's position may be late.";

  testWidgets('a weak GPS shows a light warning', (tester) async {
    await tester.pumpWidget(banners(gpsWeak: true));
    expect(find.text(weak), findsOneWidget);
  });

  testWidgets('no warning with a good signal', (tester) async {
    await tester.pumpWidget(banners());
    expect(find.text(weak), findsNothing);
  });

  testWidgets('no GPS warning when tracking is off (the other banner says so)',
      (tester) async {
    await tester.pumpWidget(banners(isTracking: false, gpsWeak: true));
    expect(find.text(weak), findsNothing);
    expect(find.textContaining('Location sharing is off'), findsOneWidget);
  });

  testWidgets('iOS: not "Always" says so and opens the settings',
      (tester) async {
    var opened = 0;
    await tester
        .pumpWidget(banners(always: true, onOpenSettings: () => opened++));
    expect(find.textContaining('"Always"'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    expect(opened, 1);
  });
}
