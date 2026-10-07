import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../../application/driver_profile_provider.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_sliver_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(driverProfileProvider);

    ref.listen(driverProfileProvider, (_, next) {
      if (next.hasError) AppSnack.error(context, l10n.profileLoadFailed);
    });

    // Until the first answer there is nothing to show; after a failure the
    // screen still renders, with placeholders.
    if (profileAsync.isLoading && !profileAsync.hasValue) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F3FF),
        body: AppLoading(),
      );
    }

    final profile = profileAsync.valueOrNull;
    final name = (profile?.fullname.isNotEmpty ?? false)
        ? profile!.fullname
        : l10n.profileDriver;
    final altPhone = profile?.alternatePhoneNo ?? '';
    final nic = profile?.nic ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: CustomScrollView(
        slivers: [
          ProfileSliverHeader(
            name: name,
            image: profile?.image,
            onEdit: () => context.push(AppRoutes.editProfile),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileSectionTitle(l10n.profileMyProfile),
                  const SizedBox(height: 12),
                  ProfileCard(children: [
                    ProfileInfoRow(
                        icon: Icons.person_outlined,
                        label: l10n.profileFullName,
                        value: name),
                    ProfileInfoRow(
                        icon: Icons.email_outlined,
                        label: l10n.profileEmail,
                        value: profile?.email ?? ''),
                    ProfileInfoRow(
                        icon: Icons.phone_outlined,
                        label: l10n.profilePhone,
                        value: profile?.phoneNo ?? '—'),
                    if (altPhone.isNotEmpty)
                      ProfileInfoRow(
                          icon: Icons.phone_callback_outlined,
                          label: l10n.profileAlternatePhone,
                          value: altPhone),
                    if (nic.isNotEmpty)
                      ProfileInfoRow(
                          icon: Icons.badge_outlined,
                          label: l10n.profileCnic,
                          value: nic),
                    ProfileInfoRow(
                        icon: Icons.home_outlined,
                        label: l10n.profileAddress,
                        value: profile?.address ?? '—'),
                  ]),
                  const SizedBox(height: 20),
                  ProfileSectionTitle(l10n.profileVehicleDetails),
                  const SizedBox(height: 12),
                  ProfileCard(children: [
                    ProfileInfoRow(
                        icon: Icons.directions_bus_outlined,
                        label: l10n.profileModel,
                        value: profile?.vanModel ?? '—'),
                    ProfileInfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: l10n.profilePlateNumber,
                        value: profile?.plateNumber ?? '—'),
                    ProfileInfoRow(
                        icon: Icons.event_seat_outlined,
                        label: l10n.profileSeats,
                        value: profile?.seats?.toString() ?? '—'),
                  ]),
                  const SizedBox(height: 20),
                  ProfileSectionTitle(l10n.profileQuickActions),
                  const SizedBox(height: 12),
                  ProfileCard(children: [
                    ProfileActionItem(
                      icon: Icons.insights_outlined,
                      label: l10n.profileDrivingStats,
                      color: const Color(0xFF6C5CE7),
                      onTap: () => context.push(AppRoutes.stats),
                    ),
                    ProfileActionItem(
                      icon: Icons.payments_outlined,
                      label: l10n.profileFeeCollection,
                      color: const Color(0xFF27AE60),
                      onTap: () => context.push(AppRoutes.feeCollection),
                    ),
                    ProfileActionItem(
                      icon: Icons.folder_outlined,
                      label: l10n.profileMyDocuments,
                      color: const Color(0xFF1B2B6B),
                      onTap: () => context.push(AppRoutes.documents),
                    ),
                    ProfileActionItem(
                      icon: Icons.lock_outlined,
                      label: l10n.profileChangePassword,
                      color: const Color(0xFFFFB800),
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                    ProfileActionItem(
                      icon: Icons.report_outlined,
                      label: l10n.profileReportIssue,
                      color: const Color(0xFFFF4B4B),
                      onTap: () => context.push(AppRoutes.reportIssue),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => showLogoutDialog(context, ref),
                      icon: const Icon(Icons.logout, color: Color(0xFFFF4B4B)),
                      label: Text(
                        l10n.profileLogout,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4B4B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF4B4B)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
