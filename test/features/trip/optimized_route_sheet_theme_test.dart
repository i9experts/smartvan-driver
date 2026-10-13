import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/theme/app_theme.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/optimized_route.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/optimized_route_sheet.dart';
import 'package:smartvan_driver/l10n/l10n.dart';

/// With the real app theme (whose ElevatedButton text colour is the same navy
/// as this button's background) the "Open in Google Maps" label was invisible.
void main() {
  testWidgets('the Open in Google Maps label is white on navy', (tester) async {
    const route = OptimizedRoute(
      stops: [OptimizedStop(sequence: 1, kidName: 'Kid One')],
      origin: GeoPoint(lat: 24.86, lng: 67.0),
      destination: GeoPoint(lat: 24.95, lng: 67.2),
    );
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: OptimizedRouteSheet(route: route)),
      ),
    ));
    await tester.pumpAndSettle();

    final label = find.text('Open in Google Maps');
    expect(label, findsOneWidget);
    final color = DefaultTextStyle.of(tester.element(label)).style.color;
    expect(color, Colors.white);
  });
}
