import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/theme/app_theme.dart';
import 'package:smartvan_driver/core/widgets/app_snack.dart';
import 'package:smartvan_driver/core/widgets/app_states.dart';
import 'package:smartvan_driver/core/widgets/gradient_header.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('AppLoading shows a spinner', (tester) async {
    await tester.pumpWidget(host(const AppLoading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppEmptyView shows title and optional message', (tester) async {
    await tester.pumpWidget(host(const AppEmptyView(
        icon: Icons.inbox, title: 'Nothing yet', message: 'Come back later')));
    expect(find.text('Nothing yet'), findsOneWidget);
    expect(find.text('Come back later'), findsOneWidget);
  });

  testWidgets('AppErrorView calls onRetry', (tester) async {
    var retries = 0;
    await tester.pumpWidget(host(AppErrorView(
        message: 'Could not load',
        retryLabel: 'Try again',
        onRetry: () => retries++)));
    expect(find.text('Could not load'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('AppErrorView without onRetry has no button', (tester) async {
    await tester.pumpWidget(host(const AppErrorView(message: 'Oops')));
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('AppSnack shows a floating snackbar in the right colour',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(children: [
            TextButton(
                onPressed: () => AppSnack.error(context, 'bad'),
                child: const Text('e')),
            TextButton(
                onPressed: () => AppSnack.success(context, 'good'),
                child: const Text('s')),
          ]),
        ),
      ),
    ));
    await tester.tap(find.text('e'));
    await tester.pump();
    expect(find.text('bad'), findsOneWidget);
    var bar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(bar.backgroundColor, AppTheme.error);
    expect(bar.behavior, SnackBarBehavior.floating);

    await tester.tap(find.text('s'));
    await tester.pumpAndSettle();
    bar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(bar.backgroundColor, AppTheme.success);
    expect(find.text('good'), findsOneWidget);
  });

  testWidgets('GradientHeader renders its child', (tester) async {
    await tester
        .pumpWidget(host(const GradientHeader(child: Text('Documents'))));
    expect(find.text('Documents'), findsOneWidget);
  });
}
