import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../profile/data/models/driver_profile.dart';
import '../../application/home_state.dart';

/// The blue top of the home screen: greeting, quick actions, location and
/// the day's numbers.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.profile,
    required this.state,
    required this.now,
    required this.chatUnread,
    required this.onMessages,
    required this.onAlerts,
    required this.onLogout,
  });

  final DriverProfile? profile;
  final HomeState? state;
  final DateTime now;
  final int chatUnread;
  final VoidCallback onMessages;
  final VoidCallback onAlerts;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fullname = profile?.fullname ?? '';
    final name = fullname.isEmpty ? l10n.homeDriverFallback : fullname;
    final firstName = name.split(' ').first;
    final address = profile?.address;
    final location =
        address == null || address.isEmpty ? l10n.homeDefaultLocation : address;
    final greeting = now.hour < 12
        ? l10n.homeGreetingMorning
        : now.hour < 17
            ? l10n.homeGreetingAfternoon
            : l10n.homeGreetingEvening;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B2B6B), Color(0xFF2D4099)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  _Avatar(image: profile?.image, name: name),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting,
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                                fontFamily: 'Poppins')),
                        Text(firstName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                  Badge(
                    isLabelVisible: chatUnread > 0,
                    label: Text('$chatUnread'),
                    backgroundColor: const Color(0xFF27AE60),
                    child: _HeaderButton(
                      tooltip: l10n.homeMessages,
                      icon: Icons.chat_bubble_outline,
                      size: 20,
                      onPressed: onMessages,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _HeaderButton(
                    tooltip: l10n.homeNavAlerts,
                    icon: Icons.notifications_outlined,
                    size: 22,
                    onPressed: onAlerts,
                  ),
                  const SizedBox(width: 8),
                  _HeaderButton(
                    tooltip: l10n.logoutTitle,
                    icon: Icons.logout,
                    size: 20,
                    onPressed: onLogout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _LocationPill(location: location),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Row(
                children: [
                  _StatChip(Icons.directions_bus_outlined,
                      '${state?.trips.length ?? 0}', l10n.homeStatTrips),
                  const SizedBox(width: 12),
                  _StatChip(Icons.people_outline,
                      '${state?.passengerCount ?? 0}', l10n.homeStatPassengers),
                  const SizedBox(width: 12),
                  _StatChip(Icons.check_circle_outline,
                      '${state?.completedTrips ?? 0}', l10n.homeStatCompleted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.tooltip,
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          tooltip: tooltip,
          icon: Icon(icon, color: Colors.white, size: size),
          onPressed: onPressed,
        ),
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.image, required this.name});

  final String? image;
  final String name;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF2D4099), Color(0xFF1B2B6B)]),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins'),
        ),
      ),
    );
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB800), width: 2.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)
        ],
      ),
      child: ClipOval(
        child: image != null
            ? Image.network(image!,
                fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback)
            : fallback,
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFFFB800), size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.icon, this.value, this.label);

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFFFFB800), size: 20),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontFamily: 'Poppins')),
            ],
          ),
        ),
      );
}
