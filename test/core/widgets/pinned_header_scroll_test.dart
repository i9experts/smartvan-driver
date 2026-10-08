import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/theme/app_theme.dart';
import 'package:smartvan_driver/core/widgets/pinned_header_scroll.dart';

void main() {
  Widget host({Future<void> Function()? onRefresh}) => MaterialApp(
        home: Scaffold(
          body: PinnedHeaderScroll(
            pinnedBar: const ColoredBox(
                color: Colors.blue,
                child: SizedBox(height: 60, child: Text('bar'))),
            onRefresh: onRefresh ?? () async {},
            children: [
              const SizedBox(height: 300, child: Text('big header')),
              for (var i = 0; i < 30; i++)
                SizedBox(height: 80, child: Text('row $i')),
            ],
          ),
        ),
      );

  double barOpacity(WidgetTester t) => t
      .widget<AnimatedOpacity>(find.byKey(const Key('pinned-header-bar')))
      .opacity;

  testWidgets('the bar is hidden at the top and shows after scrolling away',
      (tester) async {
    await tester.pumpWidget(host());
    expect(barOpacity(tester), 0);
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(barOpacity(tester), 1);
    expect(
        find.text('big header'), findsOneWidget); // still built, scrolled off
  });

  testWidgets('it hides again when scrolled back to the top', (tester) async {
    await tester.pumpWidget(host());
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 800));
    await tester.pumpAndSettle();
    expect(barOpacity(tester), 0);
  });

  testWidgets('a hidden bar does not take touches', (tester) async {
    await tester.pumpWidget(host());
    final ignoring = tester.widget<IgnorePointer>(find
        .ancestor(
            of: find.byKey(const Key('pinned-header-bar')),
            matching: find.byType(IgnorePointer))
        .first);
    expect(ignoring.ignoring, isTrue);
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    final shown = tester.widget<IgnorePointer>(find
        .ancestor(
            of: find.byKey(const Key('pinned-header-bar')),
            matching: find.byType(IgnorePointer))
        .first);
    expect(shown.ignoring, isFalse);
  });

  testWidgets('pull to refresh still works', (tester) async {
    var refreshed = 0;
    await tester.pumpWidget(host(onRefresh: () async => refreshed++));
    await tester.fling(
        find.byType(SingleChildScrollView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    expect(refreshed, 1);
  });

  testWidgets('an AppBar keeps its colour when content scrolls under it',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(
        appBar: AppBar(title: const Text('t')),
        body: ListView(children: [
          for (var i = 0; i < 40; i++) SizedBox(height: 80, child: Text('r$i')),
        ]),
      ),
    ));
    Color? bar() => tester
        .widget<Material>(find
            .descendant(
                of: find.byType(AppBar), matching: find.byType(Material))
            .first)
        .color;
    final before = bar();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(bar(), before);
    expect(bar(), AppTheme.primary);
    final appBar = tester.widget<Material>(find
        .descendant(of: find.byType(AppBar), matching: find.byType(Material))
        .first);
    expect(appBar.elevation, 0);
    expect(AppTheme.theme.appBarTheme.surfaceTintColor, Colors.transparent);
  });
}
