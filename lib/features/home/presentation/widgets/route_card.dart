import 'package:flutter/material.dart';
import '../../../../core/formatting/date_formats.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/application/start_window.dart';
import '../../../trip/data/models/assigned_route.dart';
import '../../../trip/data/models/route_passenger.dart';
import '../../../trip/data/models/trip_type.dart';

const _grey = Color(0xFF8A94A6);
const _ink = Color(0xFF1A1A2E);
const _navy = Color(0xFF1B2B6B);

/// One of today's routes: schedule, passengers and Start / Continue Trip.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.route,
    required this.now,
    required this.starting,
    required this.onStart,
    required this.onContinue,
  });

  final AssignedRoute route;
  final DateTime now;

  /// This route's trip is being started.
  final bool starting;
  final VoidCallback onStart;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final started = route.tripStarted;
    // Backend stores startTime as a UTC instant; formatTime12h converts to
    // local time (reading UTC hours showed "3:00 PM" instead of 8:00 AM).
    final startText =
        route.startTime != null ? formatTime12h(route.startTime!) : '—';
    // Mirrors the backend's 1-hour start window so the driver understands
    // *why* the button might be disabled, instead of it just failing silently.
    final withinWindow = isWithinStartWindow(route.startTime, now);
    final isDrop = route.tripType == TripType.drop;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(route.routeTitle ?? l10n.homeRouteFallback,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _ink,
                        fontFamily: 'Poppins')),
              ),
              _StatusPill(started: started),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Meta(Icons.directions_bus_outlined, route.vehicleNumber ?? '—'),
              _Meta(Icons.access_time, startText),
              _Meta(isDrop ? Icons.arrow_downward : Icons.arrow_upward,
                  isDrop ? l10n.homeRouteDrop : l10n.homeRoutePickUp),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.homeRoutePassengers(route.passengers.length),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          if (route.passengers.isEmpty)
            Text(l10n.homeRouteNoStudents,
                style: const TextStyle(
                    fontSize: 12, color: _grey, fontFamily: 'Poppins'))
          else
            for (final p in route.passengers) _PassengerRow(p),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: started
                ? OutlinedButton(
                    onPressed: route.tripDetails == null ? null : onContinue,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _navy,
                      side: const BorderSide(color: _navy),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.homeContinueTrip,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                  )
                : ElevatedButton(
                    onPressed: (starting || !withinWindow) ? null : onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: starting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(
                            withinWindow
                                ? l10n.homeStartTrip
                                : l10n.homeAvailableAt(startText),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins')),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.started});

  final bool started;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: started
              ? const Color(0xFF27AE60).withOpacity(0.1)
              : const Color(0xFFFFB800).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          started
              ? context.l10n.homeRouteInProgress
              : context.l10n.homeRouteNotStarted,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  started ? const Color(0xFF27AE60) : const Color(0xFFB8860B),
              fontFamily: 'Poppins'),
        ),
      );
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _grey),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontSize: 12, color: _grey, fontFamily: 'Poppins')),
        ],
      );
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow(this.passenger);

  final RoutePassenger passenger;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final image = passenger.image;
    final hasImage = image != null && image.isNotEmpty;
    final name = passenger.fullname;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _navy.withOpacity(0.1),
            backgroundImage: hasImage ? NetworkImage(image) : null,
            child: hasImage
                ? null
                : Text(name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name.isEmpty ? l10n.homeUnknownKid : name,
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'Poppins', color: _ink)),
          ),
          if (passenger.grade != null)
            Text(l10n.homeGrade(passenger.grade!),
                style: const TextStyle(
                    fontSize: 11, color: _grey, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
