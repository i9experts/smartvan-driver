import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/home/presentation/widgets/home_banners.dart';
import 'package:smartvan_driver/features/trip/application/tracking_replaced.dart';
import 'package:smartvan_driver/l10n/gen/app_localizations.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: TrackingReplacedBanner()),
      ),
    ));
    return container;
  }

  testWidgets('nothing is shown until another phone took the trip over',
      (tester) async {
    await pump(tester);
    expect(find.text('Trip continued on another device'), findsNothing);
  });

  testWidgets('shows the notice, and OK dismisses it', (tester) async {
    final container = await pump(tester);
    container.read(trackingReplacedProvider.notifier).state = true;
    await tester.pump();
    expect(find.text('Trip continued on another device'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(find.text('Trip continued on another device'), findsNothing);
    expect(container.read(trackingReplacedProvider), isFalse);
  });
}
