import 'package:flutter/material.dart';
import '../../../../core/formatting/money_format.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/driver_stats.dart';

const _navy = Color(0xFF1B2B6B);

Color _scoreColor(int score) {
  if (score >= 85) return const Color(0xFF27AE60);
  if (score >= 60) return const Color(0xFFFFB800);
  return const Color(0xFFE53935);
}

String _duration(AppLocalizations l10n, int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return h > 0 ? l10n.statsDurationHm(h, m) : l10n.statsDurationM(m);
}

/// Score card and the six figure tiles.
class StatsContent extends StatelessWidget {
  const StatsContent({super.key, required this.stats});

  final DriverStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final score = stats.safetyScore?.toInt() ?? 0;
    final limit = stats.speedLimitKmh;
    final overspeed = stats.overspeedCount;
    final onTime = stats.onTimePercent;

    final overspeedText = overspeed == 0
        ? l10n.statsNoOverspeed
        : limit == null
            ? l10n.statsOverspeedEventsNoLimit(overspeed)
            : l10n.statsOverspeedEvents(overspeed, limit);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 8,
                        color: _scoreColor(score),
                        backgroundColor: const Color(0xFFEAECF0),
                      ),
                    ),
                    Text('$score',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _scoreColor(score),
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.statsSafetyScore,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      overspeedText,
                      style: const TextStyle(
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _Tile(Icons.route, '${stats.trips}', l10n.statsTrips),
            _Tile(
                Icons.straighten,
                l10n.statsKm(formatAmount(stats.distanceKm)),
                l10n.statsDistance),
            _Tile(Icons.timer_outlined, _duration(l10n, stats.drivingMinutes),
                l10n.statsDrivingTime),
            _Tile(
                Icons.schedule,
                onTime == null ? '—' : l10n.statsPercent(formatAmount(onTime)),
                l10n.statsOnTimeStarts),
            _Tile(Icons.child_care, '${stats.kidsDropped}', l10n.statsDropOffs),
            _Tile(
                Icons.speed,
                l10n.statsKmh(formatAmount(stats.maxSpeedKmh ?? 0)),
                l10n.statsTopSpeed),
          ],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.value, this.label);

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _navy, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Poppins')),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8A94A6),
                  fontSize: 12,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
