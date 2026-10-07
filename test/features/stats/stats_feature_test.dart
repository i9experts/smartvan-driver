import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/stats/application/driver_stats_provider.dart';
import 'package:smartvan_driver/features/stats/data/models/driver_stats.dart';
import 'package:smartvan_driver/features/stats/data/stats_repository.dart';
import 'package:smartvan_driver/features/stats/presentation/screens/driver_stats_screen.dart';

import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeStatsRepo extends Mock implements StatsRepository {}

void main() {
  late _FakeStatsRepo repo;
  late DriverStats stats;

  setUp(() {
    repo = _FakeStatsRepo();
    stats = DriverStats.fromJson(
        asJsonMap(unwrapData(fixture('stats/driver_stats.json'))));
    when(() => repo.driverStats(days: any(named: 'days')))
        .thenAnswer((_) async => stats);
  });

  List<Override> overrides() =>
      [statsRepositoryProvider.overrideWithValue(repo)];

  test('provider asks the repository for the chosen number of days', () async {
    final c = ProviderContainer(overrides: overrides());
    addTearDown(c.dispose);
    await c.read(driverStatsProvider(30).future);
    verify(() => repo.driverStats(days: 30)).called(1);
    verifyNever(() => repo.driverStats(days: 7));
  });

  testWidgets('shows the score, the sentence and the six tiles',
      (tester) async {
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    expect(find.text('My driving stats'), findsOneWidget);
    expect(find.text('7 days'), findsOneWidget);
    expect(find.text('30 days'), findsOneWidget);
    expect(find.text('92'), findsOneWidget);
    expect(find.text('Safety score'), findsOneWidget);
    expect(find.text('3 overspeed events (limit 60 km/h)'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('210.4 km'), findsOneWidget);
    expect(find.text('9h 0m'), findsOneWidget);
    expect(find.text('88.5%'), findsOneWidget);
    expect(find.text('96'), findsOneWidget);
    expect(find.text('71.3 km/h'), findsOneWidget);
    for (final t in [
      'Trips',
      'Distance',
      'Driving time',
      'On-time starts',
      'Drop-offs',
      'Top speed'
    ]) {
      expect(find.text(t), findsOneWidget, reason: t);
    }
  });

  testWidgets('a clean record and missing optional figures', (tester) async {
    stats = const DriverStats(safetyScore: 100, speedLimitKmh: 60);
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    expect(find.text('No overspeeding — great job!'), findsOneWidget);
    expect(find.text('—'), findsOneWidget); // on-time starts unknown
    expect(find.text('0 km/h'), findsOneWidget);
    expect(find.text('0m'), findsOneWidget);
  });

  testWidgets('one overspeed event is singular', (tester) async {
    stats = const DriverStats(
        safetyScore: 80, overspeedCount: 1, speedLimitKmh: 60);
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    expect(find.text('1 overspeed event (limit 60 km/h)'), findsOneWidget);
  });

  testWidgets('the 30 days button loads the longer period', (tester) async {
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    verify(() => repo.driverStats(days: 7)).called(1);
    await tester.tap(find.text('30 days'));
    await tester.pumpAndSettle();
    verify(() => repo.driverStats(days: 30)).called(1);
  });

  testWidgets('a failure shows the message', (tester) async {
    when(() => repo.driverStats(days: any(named: 'days')))
        .thenAnswer((_) async => throw const ApiError(status: 404));
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    expect(find.text('Could not load your stats.'), findsOneWidget);
  });

  testWidgets('offline shows the no-internet text', (tester) async {
    when(() => repo.driverStats(days: any(named: 'days')))
        .thenAnswer((_) async => throw const NetworkException());
    await tester.pumpWidget(
        l10nHost(const DriverStatsScreen(), overrides: overrides()));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'No internet connection. Please check your network and try again.'),
        findsOneWidget);
  });
}
