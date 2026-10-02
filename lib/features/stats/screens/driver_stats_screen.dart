import 'package:flutter/material.dart';
import '../../../core/network/api_errors.dart';
import '../../../core/network/api_service.dart';

/// Driver's own performance for the last 7 / 30 days
/// (GET /trips/driver-stats).
class DriverStatsScreen extends StatefulWidget {
  const DriverStatsScreen({super.key});

  @override
  State<DriverStatsScreen> createState() => _DriverStatsScreenState();
}

class _DriverStatsScreenState extends State<DriverStatsScreen> {
  static const _navy = Color(0xFF1B2B6B);
  int _days = 7;
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiService.get('/trips/driver-stats?days=$_days');
      final d = res.data is Map ? res.data['data'] : null;
      setState(() => _data = d is Map ? Map<String, dynamic>.from(d) : null);
    } catch (e) {
      setState(() => _error = ApiErrors.message(e, fallback: 'Could not load your stats.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _scoreColor(int score) {
    if (score >= 85) return const Color(0xFF27AE60);
    if (score >= 60) return const Color(0xFFFFB800);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('My driving stats',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7 days')),
                ButtonSegment(value: 30, label: Text('30 days')),
              ],
              selected: {_days},
              onSelectionChanged: (s) {
                setState(() => _days = s.first);
                _load();
              },
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: CircularProgressIndicator(color: _navy)),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Text(_error!, textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Poppins')),
              )
            else if (_data != null)
              ..._content(_data!),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(Map<String, dynamic> d) {
    final score = (d['safetyScore'] as num?)?.toInt() ?? 0;
    final onTime = d['onTimePercent'];
    final overspeed = (d['overspeedCount'] as num?)?.toInt() ?? 0;
    return [
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
                  const Text('Safety score',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    overspeed == 0
                        ? 'No overspeeding — great job!'
                        : '$overspeed overspeed event${overspeed == 1 ? '' : 's'} '
                            '(limit ${d['speedLimitKmh']} km/h)',
                    style: const TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins', fontSize: 13),
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
          _tile(Icons.route, '${d['trips'] ?? 0}', 'Trips'),
          _tile(Icons.straighten, '${d['distanceKm'] ?? 0} km', 'Distance'),
          _tile(Icons.timer_outlined, _duration((d['drivingMinutes'] as num?)?.toInt() ?? 0), 'Driving time'),
          _tile(Icons.schedule, onTime == null ? '—' : '$onTime%', 'On-time starts'),
          _tile(Icons.child_care, '${d['kidsDropped'] ?? 0}', 'Drop-offs'),
          _tile(Icons.speed, '${d['maxSpeedKmh'] ?? 0} km/h', 'Top speed'),
        ],
      ),
    ];
  }

  String _duration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  Widget _tile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _navy, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Poppins')),
          Text(label,
              style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 12, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
