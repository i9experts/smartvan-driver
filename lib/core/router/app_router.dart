import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/trip/screens/trip_screen.dart';
import '../../features/passengers/screens/passengers_screen.dart';
import '../../features/passengers/screens/kid_profile_screen.dart';
import '../../features/alerts/screens/alerts_screen.dart';
import '../../features/alerts/screens/alert_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/documents_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/report_issue_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/trip',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TripScreen(trip: extra ?? {});
      },
    ),
    GoRoute(
      path: '/passengers',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PassengersScreen(trip: extra ?? {});
      },
    ),
    GoRoute(
      path: '/kid-profile',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return KidProfileScreen(kid: extra ?? {});
      },
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertsScreen(),
    ),
    GoRoute(
      path: '/alert-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AlertDetailScreen(alert: extra ?? {});
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/documents',
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/report-issue',
      builder: (context, state) => const ReportIssueScreen(),
    ),
  ],
);