import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/trip/application/battery_guard.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/oem_guide_sheet.dart';

import '../../support/l10n_host.dart';

void main() {
  const guide = OemGuide('Xiaomi', []);

  testWidgets('names the brand and opens the settings', (tester) async {
    var opened = 0;
    await tester.pumpWidget(l10nHost(Builder(
      builder: (context) => TextButton(
          onPressed: () => OemGuideSheet.show(context, guide, () => opened++),
          child: const Text('go')),
    )));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('Keep tracking alive on Xiaomi'), findsOneWidget);
    expect(find.textContaining('Xiaomi phones can stop apps'), findsOneWidget);

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(opened, 1);
    expect(find.text('Open settings'), findsNothing, reason: 'sheet closed');
  });

  testWidgets('Not now just closes it', (tester) async {
    var opened = 0;
    await tester.pumpWidget(l10nHost(Builder(
      builder: (context) => TextButton(
          onPressed: () => OemGuideSheet.show(context, guide, () => opened++),
          child: const Text('go')),
    )));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(opened, 0);
    expect(find.text('Not now'), findsNothing);
  });
}
