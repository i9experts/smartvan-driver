import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/pinned_header_scroll.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../../../chat/application/chat_providers.dart';
import '../../../checklist/application/checklist_providers.dart';
import '../../../profile/application/driver_profile_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../trip/data/models/active_trip.dart';
import '../../../trip/data/models/assigned_route.dart';
import '../../../trip/data/models/trip.dart';
import '../../application/doc_expiry.dart';
import '../../application/home_controller.dart';
import '../../application/start_trip_controller.dart';
import '../widgets/home_banners.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_header.dart';
import '../widgets/route_card.dart';
import '../widgets/trip_card.dart';

/// The driver's landing screen: the bottom-nav shell (Home / Alerts /
/// Profile) with today's routes and trips on the Home tab.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// The selected bottom-nav tab (ephemeral UI state).
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    // A trip found running on the server was resumed on this phone.
    ref.listen(homeControllerProvider, (prev, next) {
      final at = next.valueOrNull?.resumedAt;
      if (at != null && at != prev?.valueOrNull?.resumedAt) {
        AppSnack.success(context, context.l10n.homeTripResumed);
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: switch (_tab) {
        1 => const AlertsScreen(),
        2 => const ProfileScreen(),
        _ => _HomeTab(onOpenAlerts: () => setState(() => _tab = 1)),
      },
      bottomNavigationBar: _BottomNav(
        index: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab({required this.onOpenAlerts});

  final VoidCallback onOpenAlerts;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(todayChecklistProvider);
    ref.invalidate(chatUnreadProvider);
    ref.invalidate(driverProfileProvider);
    await ref.read(homeControllerProvider.notifier).refresh();
  }

  Future<void> _start(
      BuildContext context, WidgetRef ref, AssignedRoute route) async {
    final l10n = context.l10n;
    final result = await ref.read(startTripControllerProvider.notifier).start(
      route,
      completeChecklist: () async {
        AppSnack.info(context, l10n.homeChecklistFirst);
        final done = await context
            .push<bool>(AppRoutes.checklistOf(routeId: route.routeId));
        ref.invalidate(todayChecklistProvider);
        return done == true;
      },
    );
    if (!context.mounted) return;
    switch (result) {
      case TripStarted(:final trip):
        context.push(AppRoutes.tripOf(trip.id), extra: trip);
      case ChecklistNotDone():
        break;
      case TripAlreadyCompleted():
        AppSnack.info(context, l10n.homeTripAlreadyCompleted);
      case TripAlreadyStarted():
        AppSnack.info(context, l10n.homeTripAlreadyStarted);
      case StartTripFailed(:final error):
        AppSnack.error(
            context, errorText(l10n, error, fallback: l10n.homeStartFailed));
    }
  }

  void _openTrip(BuildContext context, ActiveTrip trip) {
    if (trip.id.isEmpty) return;
    context.push(AppRoutes.tripOf(trip.id), extra: trip);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final home = ref.watch(homeControllerProvider);
    final state = home.valueOrNull;
    final profile = ref.watch(driverProfileProvider).valueOrNull;
    final chatUnread = ref.watch(chatUnreadProvider).valueOrNull ?? 0;
    final startingRoute = ref.watch(startTripControllerProvider);
    final now = ref.watch(clockProvider)();
    final routes = state?.routes ?? const <AssignedRoute>[];
    final trips = state?.trips ?? const <Trip>[];

    Future<void> openMessages() async {
      await context.push(AppRoutes.chats);
      ref.invalidate(chatUnreadProvider);
    }

    return PinnedHeaderScroll(
      onRefresh: () => _refresh(ref),
      pinnedBar: HomeCompactBar(
        profile: profile,
        chatUnread: chatUnread,
        onMessages: openMessages,
        onAlerts: onOpenAlerts,
        onLogout: () => showLogoutDialog(context, ref),
      ),
      children: [
        HomeHeader(
          profile: profile,
          state: state,
          now: now,
          chatUnread: chatUnread,
          onMessages: openMessages,
          onAlerts: onOpenAlerts,
          onLogout: () => showLogoutDialog(context, ref),
        ),
        const SizedBox(height: 24),
        ActiveTripBanner(onOpen: (trip) => _openTrip(context, trip)),
        if (routes.isNotEmpty)
          ChecklistCard(
            onOpen: () async {
              await context.push<bool>(AppRoutes.checklist);
              ref.invalidate(todayChecklistProvider);
            },
          ),
        DocExpiryBanner(
          docs: expiringDocuments(profile, now),
          onTap: () => context.push(AppRoutes.documents),
        ),
        if (routes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(l10n.homeMyRouteToday),
                const SizedBox(height: 12),
                for (final route in routes)
                  RouteCard(
                    route: route,
                    now: now,
                    starting: startingRoute == route.routeId,
                    onStart: () => _start(context, ref, route),
                    onContinue: () => _openTrip(
                      context,
                      ActiveTrip.fromTrip(route.tripDetails!,
                          routeTitle: route.routeTitle),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(l10n.homeTodaysTrips),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3B69).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(l10n.homeTripsCount(trips.length),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1B3B69),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins')),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!home.hasValue)
                const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1B3B69)))
              else if (trips.isEmpty)
                const HomeEmptyState()
              else
                for (final trip in trips)
                  TripCard(
                    trip: trip,
                    onView: () => _openTrip(context, ActiveTrip.fromTrip(trip)),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
          fontFamily: 'Poppins'));
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1B3B69),
        unselectedItemColor: const Color(0xFF8A94A6),
        selectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        unselectedLabelStyle:
            const TextStyle(fontSize: 11, fontFamily: 'Poppins'),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: l10n.homeNavHome),
          BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              activeIcon: const Icon(Icons.notifications),
              label: l10n.homeNavAlerts),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined),
              activeIcon: const Icon(Icons.person),
              label: l10n.homeNavProfile),
        ],
      ),
    );
  }
}
