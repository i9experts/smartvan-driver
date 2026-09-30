import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartvan_driver/core/theme/app_theme.dart';

void main() {
  testWidgets('App theme renders a MaterialApp without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.theme,
      home: const Scaffold(body: Text('SmartVan Driver')),
    ));

    expect(find.text('SmartVan Driver'), findsOneWidget);
  });
}
