import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartvan_driver/app/app.dart';
import 'package:smartvan_driver/app/router.dart';

void main() {
  testWidgets('app shell uses routerProvider and the l10n title',
      (tester) async {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const Text('home-stub')),
    ]);
    await tester.pumpWidget(ProviderScope(
      overrides: [routerProvider.overrideWithValue(router)],
      child: const SmartVanDriverApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('home-stub'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.supportedLocales, const [Locale('en')]);
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
