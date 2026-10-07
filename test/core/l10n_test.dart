import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/l10n/l10n.dart';

void main() {
  testWidgets('context.l10n resolves English strings', (tester) async {
    late String title;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        title = context.l10n.appTitle;
        return const SizedBox();
      }),
    ));
    expect(title, 'SmartVan Driver');
    expect(AppLocalizations.supportedLocales, [const Locale('en')]);
  });
}
