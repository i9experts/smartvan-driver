import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/router/app_routes.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/trip/screens/trip_screen.dart';
import '../features/passengers/screens/passengers_screen.dart';
import '../features/passengers/screens/kid_profile_screen.dart';
import '../features/alerts/data/models/alert.dart';
import '../features/alerts/presentation/screens/alerts_screen.dart';
import '../features/alerts/presentation/screens/alert_detail_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/documents_screen.dart';
import '../features/profile/presentation/screens/change_password_screen.dart';
import '../features/profile/presentation/screens/report_issue_screen.dart';
import '../features/fees/presentation/screens/fee_collection_screen.dart';
import '../features/scan/screens/scan_screen.dart';
import '../features/checklist/presentation/screens/checklist_screen.dart';
import '../features/stats/presentation/screens/driver_stats_screen.dart';
import '../features/chat/chat_api.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/chat/screens/conversations_screen.dart';

/// The one GoRouter. Transitional global: sign-out still navigates through it
/// until AppSession moves into the auth feature.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.legacyTrip,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TripScreen(trip: extra ?? {});
      },
    ),
    GoRoute(
      path: AppRoutes.legacyPassengers,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PassengersScreen(trip: extra ?? {});
      },
    ),
    GoRoute(
      path: AppRoutes.legacyKid,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return KidProfileScreen(kid: extra ?? {});
      },
    ),
    GoRoute(
      path: AppRoutes.alerts,
      builder: (context, state) => const AlertsScreen(),
    ),
    GoRoute(
      path: AppRoutes.alertDetail,
      builder: (context, state) => AlertDetailScreen(
        alertId: state.pathParameters['alertId']!,
        alert: state.extra is Alert ? state.extra as Alert : null,
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.documents,
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.reportIssue,
      builder: (context, state) => const ReportIssueScreen(),
    ),
    GoRoute(
      path: AppRoutes.chats,
      builder: (context, state) => const ConversationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.legacyChat,
      builder: (context, state) =>
          ChatScreen(conversation: state.extra as Conversation),
    ),
    GoRoute(
      path: AppRoutes.stats,
      builder: (context, state) => const DriverStatsScreen(),
    ),
    GoRoute(
      path: AppRoutes.checklist,
      builder: (context, state) =>
          ChecklistScreen(routeId: state.uri.queryParameters['routeId']),
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.feeCollection,
      builder: (context, state) => const FeeCollectionScreen(),
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) => appRouter);
