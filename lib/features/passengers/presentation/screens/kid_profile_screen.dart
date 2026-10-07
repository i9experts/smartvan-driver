import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/application/trip_tracking.dart';
import '../../application/passengers_controller.dart';
import '../../data/models/passenger.dart';
import '../widgets/kid_profile_widgets.dart';

/// One kid: school, grade, parent contact and address. [kidId] comes from
/// the route; [kid] is an optional already-loaded copy (without it the kid is
/// looked up in the running trip's passengers).
class KidProfileScreen extends ConsumerWidget {
  const KidProfileScreen({super.key, required this.kidId, this.kid});

  final String kidId;
  final Passenger? kid;

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Passenger? found = kid;
    if (found == null) {
      final tripId = ref.watch(tripTrackingProvider.select((s) => s.tripId));
      if (tripId != null) {
        found = ref
            .watch(passengersControllerProvider(tripId))
            .valueOrNull
            ?.passengers
            .where((p) => p.id == kidId)
            .firstOrNull;
      }
    }

    final Widget content;
    if (found == null) {
      content = AppEmptyView(
          icon: Icons.person_off_outlined, title: l10n.kidProfileNotFound);
    } else {
      content = _KidProfileBody(kid: found, onCall: _callPhone);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          GradientHeader(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 20, 24),
            child: _KidHeader(kid: found, onBack: () => context.pop()),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _KidHeader extends StatelessWidget {
  const _KidHeader({required this.kid, required this.onBack});

  final Passenger? kid;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = (kid?.fullname.isNotEmpty ?? false)
        ? kid!.fullname
        : l10n.passengersUnknownKid;
    final location = kid?.parent.address ?? l10n.kidProfileDefaultLocation;
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: onBack,
            ),
            Text(
              l10n.kidProfileTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFB800), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipOval(
            child: kid?.image != null
                ? Image.network(kid!.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _AvatarFallback(name: name))
                : _AvatarFallback(name: name),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Color(0xFFFFB800), size: 14),
            const SizedBox(width: 4),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KidProfileBody extends StatelessWidget {
  const _KidProfileBody({required this.kid, required this.onCall});

  final Passenger kid;
  final Future<void> Function(String phone) onCall;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phone = kid.parent.phoneNo ?? '—';
    final altPhone = kid.parent.alternatePhoneNo ?? '—';
    final address = kid.parent.address ?? '—';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KidSectionTitle(l10n.kidProfileStudentInfo),
          const SizedBox(height: 12),
          KidInfoCard(children: [
            KidInfoRow(
                icon: Icons.school_outlined,
                label: l10n.kidProfileSchool,
                value: kid.schoolName ?? '—'),
            KidInfoRow(
                icon: Icons.class_outlined,
                label: l10n.kidProfileGrade,
                value: kid.grade ?? '—'),
          ]),
          const SizedBox(height: 20),
          KidSectionTitle(l10n.kidProfileParentContact),
          const SizedBox(height: 12),
          KidInfoCard(children: [
            KidInfoRow(
                icon: Icons.phone_outlined,
                label: l10n.kidProfilePhone,
                value: phone,
                onCall: () => onCall(phone)),
            KidInfoRow(
                icon: Icons.phone_callback_outlined,
                label: l10n.kidProfileAltPhone,
                value: altPhone,
                onCall: () => onCall(altPhone)),
          ]),
          const SizedBox(height: 20),
          KidSectionTitle(l10n.kidProfileHomeAddress),
          const SizedBox(height: 12),
          KidAddressCard(address: address),
          const SizedBox(height: 20),
          if (phone != '—')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => onCall(phone),
                icon: const Icon(Icons.call, size: 20),
                label: Text(
                  l10n.kidProfileCallParent,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B2B6B), Color(0xFF2D4099)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'K',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
