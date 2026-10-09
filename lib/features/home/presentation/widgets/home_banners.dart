import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/l10n.dart';
import '../../../checklist/application/checklist_providers.dart';
import '../../../trip/application/trip_tracking.dart';
import '../../../trip/data/models/active_trip.dart';
import '../../application/doc_expiry.dart';

/// Green banner while this phone is sharing the van's location.
class ActiveTripBanner extends ConsumerWidget {
  const ActiveTripBanner({super.key, required this.onOpen});

  final void Function(ActiveTrip trip) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(tripTrackingProvider);
    final trip = tracking.trip;
    if (!tracking.isTracking || trip == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    final title = trip.routeTitle ?? trip.name ?? l10n.homeTripInProgress;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Material(
        color: const Color(0xFF27AE60),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onOpen(trip),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.gps_fixed, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.homeTripInProgress,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Today's van check status; tap opens the check.
class ChecklistCard extends ConsumerWidget {
  const ChecklistCard({super.key, required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Hidden while loading or if the backend doesn't support it yet.
    final t = ref.watch(todayChecklistProvider).valueOrNull;
    if (t == null) return const SizedBox.shrink();
    final done = t.done;
    final color = !done
        ? (t.required ? const Color(0xFFE53935) : const Color(0xFFFEC610))
        : (t.allOk ? const Color(0xFF27AE60) : const Color(0xFFFEC610));
    final title = !done
        ? l10n.homeChecklistNotDone
        : (t.allOk ? l10n.homeChecklistDone : l10n.homeChecklistDoneIssues);
    final subtitle = !done
        ? (t.required ? l10n.homeChecklistRequired : l10n.homeChecklistQuick)
        : l10n.homeChecklistUpdate;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpen,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Icon(done ? Icons.fact_check : Icons.checklist, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      Text(subtitle,
                          style: const TextStyle(
                              color: Color(0xFF8A94A6),
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF8A94A6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Warns when the driving licence or vehicle card expires within 30 days.
class DocExpiryBanner extends StatelessWidget {
  const DocExpiryBanner({super.key, required this.docs, required this.onTap});

  final List<DocExpiry> docs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final color = docs.any((d) => d.expired)
        ? const Color(0xFFE53935)
        : const Color(0xFFFEC610);
    final text = docs.map((d) => _line(l10n, d)).join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Material(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.badge_outlined, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.homeDocBanner(text),
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _line(AppLocalizations l10n, DocExpiry d) {
    final doc = d.document == ExpiringDocument.licence
        ? l10n.homeDocLicence
        : l10n.homeDocVehicleCard;
    if (d.days < 0) return l10n.homeDocExpired(doc);
    if (d.days == 0) return l10n.homeDocExpiresToday(doc);
    return l10n.homeDocExpiresIn(doc, d.days);
  }
}
