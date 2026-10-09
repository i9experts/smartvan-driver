import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/data/models/trip_type.dart';
import '../../data/models/kid_trip_status.dart';
import '../../data/models/passenger.dart';

/// How long the driver should wait before "move on" is offered.
const waitBeforeNoShow = Duration(minutes: 2);

/// One kid on the trip: avatar, name, distance, pick/drop controls and the
/// small row for absent / no-show / at-stop / waiting timer.
class PassengerCard extends StatelessWidget {
  const PassengerCard({
    super.key,
    required this.passenger,
    required this.status,
    required this.unsynced,
    required this.stopBusy,
    required this.now,
    required this.onOpenProfile,
    required this.onMessage,
    required this.onPick,
    required this.onDrop,
    required this.onArrived,
    required this.onNoShow,
  });

  final Passenger passenger;

  /// Pick state, with any queued (not yet synced) action applied.
  final KidTripStatus status;
  final bool unsynced;
  final bool stopBusy;

  /// "Now", so the waiting timer can tick.
  final DateTime now;
  final VoidCallback onOpenProfile;
  final VoidCallback onMessage;
  final VoidCallback onPick;
  final VoidCallback onDrop;
  final VoidCallback onArrived;
  final VoidCallback onNoShow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kid = passenger;
    final name = kid.fullname.isEmpty ? l10n.passengersUnknownKid : kid.fullname;
    final isPicked = status == KidTripStatus.picked;
    final isDropped = status == KidTripStatus.dropped;
    final schoolName = kid.schoolName ?? '—';
    final distance = kid.distance ?? '—';
    final stopRow = _stopRow(context, isPicked, isDropped);

    return Opacity(
      // Absent / no-show kids are dimmed so the driver's eye goes to riders.
      opacity: (kid.absent || kid.noShow) && !isPicked && !isDropped ? 0.6 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar — tap to view the full profile (address, parent
                  // contact, alternate phone).
                  GestureDetector(
                    onTap: onOpenProfile,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isPicked
                              ? const Color(0xFF27AE60)
                              : isDropped
                                  ? const Color(0xFF1B3B69)
                                  : const Color(0xFFEAECF0),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: kid.image != null
                            ? Image.network(kid.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _AvatarFallback(name: name))
                            : _AvatarFallback(name: name),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            if (unsynced) ...[
                              const SizedBox(width: 6),
                              Tooltip(
                                message: l10n.passengersSavedOffline,
                                child: const Icon(Icons.cloud_upload_outlined,
                                    size: 16, color: Color(0xFFFEC610)),
                              ),
                            ],
                            if (kid.id.isNotEmpty)
                              IconButton(
                                tooltip: l10n.passengersMessageParent,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.chat_bubble_outline,
                                    size: 18, color: Color(0xFF1B3B69)),
                                onPressed: onMessage,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 12, color: Color(0xFF8A94A6)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                distance != '—'
                                    ? l10n.passengersAway(distance)
                                    : schoolName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8A94A6),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _ActionButton(
                    isPicked: isPicked,
                    isDropped: isDropped,
                    onPick: onPick,
                    onDrop: onDrop,
                  ),
                ],
              ),
              if (stopRow != null) ...[
                const SizedBox(height: 6),
                stopRow,
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Small row under the card: absent / no-show / at-stop / waiting timer.
  Widget? _stopRow(BuildContext context, bool isPicked, bool isDropped) {
    final l10n = context.l10n;
    final kid = passenger;
    Widget chip(IconData icon, String text, Color color) => Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600)),
            ),
          ],
        );

    if (kid.absent && !isPicked && !isDropped) {
      final note = kid.absenceNote;
      return chip(
        Icons.event_busy,
        note != null && note.isNotEmpty
            ? l10n.passengersAbsentWithNote(note)
            : l10n.passengersAbsentNoNote,
        const Color(0xFF8A94A6),
      );
    }
    if (kid.noShow && !isPicked) {
      return chip(Icons.directions_walk, l10n.passengersNotAtStop,
          const Color(0xFFE53935));
    }
    if (isDropped) return null;

    final isDropTrip = kid.tripType == TripType.drop;
    final relevant = isDropTrip ? isPicked : !isPicked;
    if (!relevant) return null;

    final since = kid.waitingSince?.toLocal();
    if (since == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: stopBusy ? null : onArrived,
          icon: const Icon(Icons.where_to_vote_outlined, size: 18),
          label: Text(isDropTrip ? l10n.passengersAtHome : l10n.passengersAtStop),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              foregroundColor: const Color(0xFF1B3B69)),
        ),
      );
    }

    final waited = now.difference(since);
    final ss = (waited.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      children: [
        Expanded(
            child: chip(Icons.timer_outlined,
                l10n.passengersWaiting(waited.inMinutes, ss), const Color(0xFFFEC610))),
        if (!isDropTrip && waited >= waitBeforeNoShow)
          TextButton(
            onPressed: stopBusy ? null : onNoShow,
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
                visualDensity: VisualDensity.compact),
            child: Text(l10n.passengersNotHere),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.isPicked,
    required this.isDropped,
    required this.onPick,
    required this.onDrop,
  });

  final bool isPicked;
  final bool isDropped;
  final VoidCallback onPick;
  final VoidCallback onDrop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (isDropped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF8A94A6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          l10n.passengersStatusDropped,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A94A6),
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    if (isPicked) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.passengersStatusPicked,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF27AE60),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDrop,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3B69).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF1B3B69).withValues(alpha: 0.3)),
              ),
              child: Text(
                l10n.passengersDropButton,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B3B69),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onPick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFEC610).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEC610).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_upward, size: 14, color: Color(0xFFFEC610)),
            const SizedBox(width: 4),
            Text(
              l10n.passengersPickUp,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFEC610),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B3B69).withValues(alpha: 0.7),
            const Color(0xFF2D4099).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'K',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
