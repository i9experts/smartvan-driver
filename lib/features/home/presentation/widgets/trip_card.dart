import 'package:flutter/material.dart';
import '../../../../core/formatting/date_formats.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/data/models/trip.dart';
import '../../../trip/data/models/trip_status.dart';
import '../../../trip/data/models/trip_type.dart';

const _grey = Color(0xFF8A94A6);
const _navy = Color(0xFF1B3B69);

/// One entry of "Today's Trips".
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onView});

  final Trip trip;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isActive = trip.status == TripStatus.ongoing;
    final isCompleted = trip.status == TripStatus.completed;
    final (statusColor, statusText) = isActive
        ? (const Color(0xFF27AE60), l10n.homeTripActive)
        : isCompleted
            ? (_grey, l10n.homeTripCompleted)
            : (const Color(0xFFFEC610), l10n.homeTripStarting);
    final barColors = isCompleted
        ? const [_grey, _grey]
        : isActive
            ? const [Color(0xFF27AE60), Color(0xFF2ECC71)]
            : const [_navy, Color(0xFF2D4099)];
    final date =
        trip.createdAt != null ? formatDayMonthYear(trip.createdAt!) : '—';
    final startTime =
        trip.startTime != null ? formatTime12h(trip.startTime!) : '—';
    final shift =
        trip.type == TripType.drop ? l10n.homeTripDropOff : l10n.homeTripPickUp;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: barColors),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_navy, Color(0xFF2D4099)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_bus,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip.name ?? l10n.homeTripFallback,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                  fontFamily: 'Poppins')),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: statusColor, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              Text(statusText,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _InfoChip(Icons.calendar_today_outlined, date),
                    const SizedBox(width: 8),
                    _InfoChip(Icons.wb_sunny_outlined, shift),
                    const SizedBox(width: 8),
                    _InfoChip(Icons.access_time, startTime),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isCompleted ? null : onView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEC610),
                      foregroundColor: _navy,
                      disabledBackgroundColor: _grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            isCompleted
                                ? l10n.homeTripCompleted
                                : l10n.homeViewTrip,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: isCompleted ? _grey : _navy)),
                        if (!isCompleted) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              size: 18, color: _navy),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F3FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 12, color: _navy),
              const SizedBox(width: 4),
              Expanded(
                child: Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      );
}
