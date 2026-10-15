import 'package:flutter/material.dart';
import '../../../../core/formatting/pkt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/completed_trip.dart';
import '../../data/models/trip_details.dart';
import 'trip_history_labels.dart';

/// White rounded card with a title, shared by the details sections.
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );
}

/// Route, type, date, start / end, duration and distance.
class TripSummaryCard extends StatelessWidget {
  const TripSummaryCard({super.key, required this.trip});

  final CompletedTrip trip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final when = trip.when;
    final rows = <(String, String)>[
      (l10n.tripDetailsRoute, trip.routeName ?? l10n.tripNameFallback),
      (l10n.tripDetailsType, tripTypeLabel(l10n, trip.tripType)),
      (l10n.tripDetailsDate, when == null ? '—' : formatDatePkt(when, locale)),
      (
        l10n.tripDetailsStarted,
        trip.startedAt == null ? '—' : formatTimePkt(trip.startedAt!)
      ),
      (
        l10n.tripDetailsEnded,
        trip.endedAt == null ? '—' : formatTimePkt(trip.endedAt!)
      ),
      (l10n.tripDetailsDuration, durationText(l10n, trip.durationSeconds)),
      (
        l10n.tripDetailsDistance,
        l10n.tripDistanceKm(kmText(trip.distanceMeters))
      ),
    ];
    return DetailsCard(
      title: l10n.tripDetailsSummary,
      child: Column(
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(label,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textMuted)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(value,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Every student with what happened to them and when.
class TripStudentsCard extends StatelessWidget {
  const TripStudentsCard({super.key, required this.stops});

  final List<TripStop> stops;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final students = [for (final s in stops) ...s.students];
    return DetailsCard(
      title: '${l10n.tripDetailsStudents} (${students.length})',
      child: students.isEmpty
          ? Text(l10n.tripDetailsNoStudents,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted))
          : Column(
              children: [
                for (final s in students) _StudentRow(student: s),
              ],
            ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student});

  final TripStudent student;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = studentStatusColor(student.status);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(student.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark)),
          ),
          if (student.at != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Text(formatTimePkt(student.at!),
                  style:
                      const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(studentStatusLabel(l10n, student.status),
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }
}

/// SOS, overspeed, delay and tracking-lost alerts raised during the trip.
class TripAlertsCard extends StatelessWidget {
  const TripAlertsCard({super.key, required this.alerts});

  final List<TripAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailsCard(
      title: l10n.tripDetailsAlerts,
      child: alerts.isEmpty
          ? Text(l10n.tripDetailsNoAlerts,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted))
          : Column(
              children: [
                for (final a in alerts)
                  _AlertRow(alert: a, onTap: () => _showAlert(context, a)),
              ],
            ),
    );
  }

  void _showAlert(BuildContext context, TripAlert alert) {
    final l10n = context.l10n;
    final color = alertKindColor(alert.type);
    showAppBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(alertKindIcon(alert.type), color: color, size: 40),
              const SizedBox(height: 8),
              Text(alert.title ?? alertKindLabel(l10n, alert.type),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              if (alert.at != null) ...[
                const SizedBox(height: 4),
                Text(formatTimePkt(alert.at!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textMuted)),
              ],
              if (alert.message != null) ...[
                const SizedBox(height: 12),
                Text(alert.message!, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.alert, required this.onTap});

  final TripAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = alertKindColor(alert.type);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(alertKindIcon(alert.type), size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(alertKindLabel(l10n, alert.type),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark)),
            ),
            if (alert.at != null)
              Text(formatTimePkt(alert.at!),
                  style:
                      const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}
