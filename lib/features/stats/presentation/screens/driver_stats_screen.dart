import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/driver_stats_provider.dart';
import '../widgets/stats_content.dart';

/// Driver's own performance for the last 7 / 30 days.
class DriverStatsScreen extends ConsumerStatefulWidget {
  const DriverStatsScreen({super.key});

  @override
  ConsumerState<DriverStatsScreen> createState() => _DriverStatsScreenState();
}

class _DriverStatsScreenState extends ConsumerState<DriverStatsScreen> {
  static const _navy = Color(0xFF1B3B69);
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statsAsync = ref.watch(driverStatsProvider(_days));

    final Widget content;
    if (statsAsync.hasValue) {
      content = StatsContent(stats: statsAsync.requireValue);
    } else if (statsAsync.hasError) {
      content = Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Text(
          errorText(l10n, statsAsync.error!, fallback: l10n.statsLoadFailed),
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      );
    } else {
      content = const Padding(
        padding: EdgeInsets.only(top: 80),
        child: AppLoading(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(l10n.statsTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(driverStatsProvider(_days));
          try {
            await ref.read(driverStatsProvider(_days).future);
          } catch (_) {
            // The error view shows it.
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 7, label: Text(l10n.statsDaysOption(7))),
                ButtonSegment(value: 30, label: Text(l10n.statsDaysOption(30))),
              ],
              selected: {_days},
              onSelectionChanged: (s) => setState(() => _days = s.first),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
