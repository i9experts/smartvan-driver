import 'package:flutter/material.dart';
import '../../../../core/formatting/pkt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/data/models/trip_type.dart';
import '../../data/models/completed_trip.dart';
import '../../data/models/trip_details.dart';

/// "41 min" / "1 h 5 min".
String durationText(AppLocalizations l10n, int seconds) {
  final d = durationParts(seconds);
  return d.hours == 0
      ? l10n.tripDurationMinutes(d.minutes)
      : l10n.tripDurationHoursMinutes(d.hours, d.minutes);
}

/// "7:00 AM – 7:41 AM" (PKT); a missing end shows as "—".
String timeRangeText(AppLocalizations l10n, CompletedTrip trip) =>
    l10n.tripTimeRange(
      trip.startedAt == null ? '—' : formatTimePkt(trip.startedAt!),
      trip.endedAt == null ? '—' : formatTimePkt(trip.endedAt!),
    );

String tripTypeLabel(AppLocalizations l10n, TripType type) =>
    type == TripType.drop ? l10n.historyFilterDrop : l10n.historyFilterPick;

String studentStatusLabel(AppLocalizations l10n, StudentOutcome s) =>
    switch (s) {
      StudentOutcome.picked => l10n.tripStudentPicked,
      StudentOutcome.dropped => l10n.tripStudentDropped,
      StudentOutcome.absent => l10n.tripStudentAbsent,
      StudentOutcome.noShow => l10n.tripStudentNoShow,
      StudentOutcome.pending ||
      StudentOutcome.unknown =>
        l10n.tripStudentPending,
    };

Color studentStatusColor(StudentOutcome s) => switch (s) {
      StudentOutcome.picked || StudentOutcome.dropped => AppTheme.success,
      StudentOutcome.absent || StudentOutcome.noShow => AppTheme.error,
      StudentOutcome.pending || StudentOutcome.unknown => AppTheme.textMuted,
    };

String alertKindLabel(AppLocalizations l10n, TripAlertKind k) => switch (k) {
      TripAlertKind.sos => l10n.tripAlertSos,
      TripAlertKind.overspeed => l10n.tripAlertOverspeed,
      TripAlertKind.trafficDelay => l10n.tripAlertTrafficDelay,
      TripAlertKind.trackingLost => l10n.tripAlertTrackingLost,
      TripAlertKind.unknown => l10n.tripAlertOther,
    };

IconData alertKindIcon(TripAlertKind k) => switch (k) {
      TripAlertKind.sos => Icons.sos,
      TripAlertKind.overspeed => Icons.speed,
      TripAlertKind.trafficDelay => Icons.traffic,
      TripAlertKind.trackingLost => Icons.location_off,
      TripAlertKind.unknown => Icons.warning_amber_rounded,
    };

Color alertKindColor(TripAlertKind k) => switch (k) {
      TripAlertKind.sos => AppTheme.error,
      TripAlertKind.overspeed => const Color(0xFFF2994A),
      TripAlertKind.trafficDelay => const Color(0xFFF2C94C),
      TripAlertKind.trackingLost => AppTheme.textMuted,
      TripAlertKind.unknown => AppTheme.textMuted,
    };
