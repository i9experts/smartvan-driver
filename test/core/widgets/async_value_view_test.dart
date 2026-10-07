import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/widgets/app_states.dart';
import 'package:smartvan_driver/core/widgets/async_value_view.dart';

import '../../support/l10n_host.dart';

void main() {
  testWidgets('loading shows a spinner', (tester) async {
    await tester.pumpWidget(l10nHost(AsyncValueView<int>(
        value: const AsyncLoading(), data: (d) => Text('$d'))));
    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('data shows the data builder', (tester) async {
    await tester.pumpWidget(l10nHost(AsyncValueView<int>(
        value: const AsyncData(7), data: (d) => Text('value $d'))));
    expect(find.text('value 7'), findsOneWidget);
  });

  testWidgets('error shows the localized message and a working Retry',
      (tester) async {
    var retried = 0;
    await tester.pumpWidget(l10nHost(AsyncValueView<int>(
      value: const AsyncError<int>(NetworkException(), StackTrace.empty),
      data: (d) => Text('$d'),
      onRetry: () => retried++,
    )));
    expect(
        find.text(
            'No internet connection. Please check your network and try again.'),
        findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retried, 1);
  });

  testWidgets('error without onRetry has no button and uses the fallback',
      (tester) async {
    await tester.pumpWidget(l10nHost(AsyncValueView<int>(
      value: const AsyncError<int>(ApiError(status: 404), StackTrace.empty),
      data: (d) => Text('$d'),
      errorFallback: 'Could not load your stats.',
    )));
    expect(find.text('Could not load your stats.'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('a refresh keeps showing the old data', (tester) async {
    await tester.pumpWidget(l10nHost(AsyncValueView<int>(
      value:
          const AsyncData<int>(3).copyWithPrevious(const AsyncLoading<int>()),
      data: (d) => Text('value $d'),
    )));
    expect(find.text('value 3'), findsOneWidget);
  });
}
