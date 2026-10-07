import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../core/session/app_session.dart';
import '../../../core/network/api_service.dart';
import '../../trip/application/trip_tracking.dart';
import '../../trip/data/models/active_trip.dart';
import '../../../core/router/app_routes.dart';
import '../../checklist/application/checklist_providers.dart';
import '../../chat/data/chat_repository.dart';
import '../../../core/network/api_errors.dart';
import '../../alerts/presentation/screens/alerts_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _profile;
  List<dynamic> _trips = [];
  List<dynamic> _myRoutes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // ref.invalidate reads the ProviderScope inherited widget, which isn't
    // allowed during initState - defer to after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  int _chatUnread = 0;

  Future<void> _loadChatUnread() async {
    try {
      final n = await ref.read(chatRepositoryProvider).unread();
      if (mounted) setState(() => _chatUnread = n);
    } catch (_) {
      // chat not available — keep the icon without a badge
    }
  }

  Future<void> _loadData() async {
    ref.invalidate(todayChecklistProvider);
    _loadChatUnread();
    await Future.wait([_loadProfile(), _loadTrips(), _loadMyRoutes()]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadMyRoutes() async {
    try {
      final response = await ApiService.get('/route/getAssignedTripByDriver');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw['data'];
        final routes = data is List ? data : [];
        if (mounted) setState(() => _myRoutes = routes);
        await _reconcileTracking(routes);
      }
    } catch (e) {
      // No van assigned / no routes today / driver inactive — all handled
      // as "nothing to show" rather than a crash. The empty state below
      // covers this gracefully.
      if (mounted) setState(() => _myRoutes = []);
    }
  }

  /// Keeps on-device tracking in line with the server:
  /// - a trip is ongoing on the server but this device isn't tracking it
  ///   (app was killed / reinstalled / driver switched phone) → resume;
  /// - this device is tracking but no route has a started trip any more
  ///   (ended from the admin panel) → stop the GPS + foreground service.
  Future<void> _reconcileTracking(List routes) async {
    final tracking = ref.read(tripTrackingProvider);
    final notifier = ref.read(tripTrackingProvider.notifier);

    Map<String, dynamic>? ongoing;
    for (final r in routes) {
      if (r is Map && r['TripStarted'] == true && r['tripDetails'] is Map) {
        ongoing = {
          ...Map<String, dynamic>.from(r['tripDetails'] as Map),
          'schoolRoute': r['routeTitle'],
        };
        break;
      }
    }

    if (ongoing != null) {
      final id = ActiveTrip.fromJson(ongoing).id;
      if (!tracking.isTracking || tracking.tripId != id) {
        final result = await notifier.start(ActiveTrip.fromJson(ongoing));
        if (result == TrackingStartResult.started && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Your ongoing trip was resumed — location sharing is on.'),
              backgroundColor: Color(0xFF27AE60),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else if (tracking.isTracking) {
      await notifier.stop();
    }
  }

  Widget _buildActiveTripBanner() {
    final tracking = ref.watch(tripTrackingProvider);
    if (!tracking.isTracking || tracking.trip == null) {
      return const SizedBox.shrink();
    }
    final title =
        tracking.trip!.routeTitle ?? tracking.trip!.name ?? 'Trip in progress';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Material(
        color: const Color(0xFF27AE60),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.go('/trip', extra: tracking.trip!.toJson()),
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
                      const Text('Trip in progress',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      Text(title.toString(),
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

  Future<void> _loadProfile() async {
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200) {
        final raw = response.data;
        if (!mounted) return;
        setState(() => _profile = raw['data'] ?? raw);
      }
    } catch (e) {
      // Non-fatal — name display falls back to a default, and pull-to-refresh
      // recovers it — but a real failure (timeout/500) shouldn't be mute.
      debugPrint('Failed to load driver profile: $e');
    }
  }

  Future<void> _loadTrips() async {
    try {
      final response = await ApiService.get('/trips/getDriverTrips');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw['data'] ?? raw ?? [];
        if (!mounted) return;
        setState(() => _trips = data is List ? data : []);
      }
    } catch (e) {
      // Non-fatal — falls back to the "No Trip Today" empty state, and
      // pull-to-refresh recovers it — but a real failure shouldn't be mute.
      debugPrint('Failed to load driver trips: $e');
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text(AppSession.logoutConfirmText(),
            style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style:
                    TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AppSession.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B4B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHome();
      case 1:
        return const AlertsScreen();
      case 2:
        return const ProfileScreen();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    final name = _profile?['fullname'] ?? _profile?['name'] ?? 'Driver';
    final firstName = name.toString().split(' ').first;
    final location = _profile?['address'] ?? 'Karachi, Pakistan';

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF1B2B6B),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Hero Header
            Container(
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
                          // Avatar
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFFFB800), width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: _profile?['image'] != null
                                  ? Image.network(_profile!['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildAvatarFallback(name))
                                  : _buildAvatarFallback(name),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getGreeting()},',
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  firstName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Badge(
                            isLabelVisible: _chatUnread > 0,
                            label: Text('$_chatUnread'),
                            backgroundColor: const Color(0xFF27AE60),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                tooltip: 'Messages',
                                icon: const Icon(Icons.chat_bubble_outline,
                                    color: Colors.white, size: 20),
                                onPressed: () async {
                                  await context.push('/chats');
                                  _loadChatUnread();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 22),
                              onPressed: () =>
                                  setState(() => _currentIndex = 1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.logout,
                                  color: Colors.white, size: 20),
                              onPressed: _logout,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location pill
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
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
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      child: Row(
                        children: [
                          _buildStatChip(Icons.directions_bus_outlined,
                              '${_trips.length}', 'Trips Today'),
                          const SizedBox(width: 12),
                          _buildStatChip(Icons.people_outline,
                              '${_totalPassengerCount()}', 'Passengers'),
                          const SizedBox(width: 12),
                          _buildStatChip(
                              Icons.check_circle_outline,
                              _trips
                                  .where((t) =>
                                      (t['status'] ?? '')
                                          .toString()
                                          .toLowerCase() ==
                                      'end')
                                  .length
                                  .toString(),
                              'Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildActiveTripBanner(),

            _buildChecklistCard(),

            _buildDocExpiryBanner(),

            // My Route Today — schedule + passengers, independent of
            // whether a trip has actually been started yet.
            if (_myRoutes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Route Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._myRoutes.map((route) => _buildRouteCard(route)),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Today's Trips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today's Trips",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B2B6B).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_trips.length} trips',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1B2B6B),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF1B2B6B)))
                      : _trips.isEmpty
                          ? _buildEmptyState()
                          : Column(
                              children: _trips
                                  .map((trip) => _buildTripCard(trip))
                                  .toList(),
                            ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatTime12Hour(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  int _totalPassengerCount() {
    final ids = <String>{};
    for (final route in _myRoutes) {
      final passengers = (route['passengers'] as List?) ?? [];
      for (final p in passengers) {
        final id = p['kidId']?.toString();
        if (id != null) ids.add(id);
      }
    }
    return ids.length;
  }

  bool _startingRouteId = false;
  String? _startingRoute;

  Future<void> _startTripFromRoute(Map<String, dynamic> route) async {
    final routeId = route['routeId']?.toString();
    if (routeId == null) return;
    setState(() {
      _startingRouteId = true;
      _startingRoute = routeId;
    });
    var needsChecklist = false;
    try {
      final response = await ApiService.post('/trips/startTrip', {
        'routeId': routeId,
        'type': route['tripType'] ?? 'pick',
      });
      final data = response.data['data'];
      await _loadData();
      if (mounted && data != null) {
        // The raw trip document has no route title of its own (just a
        // bare routeId) — merge it in from the route we already have,
        // otherwise the trip screen permanently shows "School Route: —".
        final enriched = {
          ...Map<String, dynamic>.from(data),
          'schoolRoute': route['routeTitle'],
        };
        context.go('/trip', extra: enriched);
      }
    } on DioException catch (e) {
      // School requires today's van check first — open it, then retry.
      if (ApiErrors.code(e) == 'CHECKLIST_REQUIRED') {
        needsChecklist = true;
        return;
      }
      final message = e.response?.data?['message']?.toString() ??
          'Failed to start trip. Please try again.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start trip. Please try again.'),
            backgroundColor: Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _startingRouteId = false;
          _startingRoute = null;
        });
      }
      if (needsChecklist && mounted) {
        _openChecklistThenStart(route);
      }
    }
  }

  Future<void> _openChecklistThenStart(Map<String, dynamic> route) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please complete today\'s van check first.'),
      behavior: SnackBarBehavior.floating,
    ));
    final done = await context.push<bool>(
        AppRoutes.checklistOf(routeId: route['routeId']?.toString()));
    if (!mounted) return;
    ref.invalidate(todayChecklistProvider);
    if (done == true) await _startTripFromRoute(route);
  }

  /// Days until a profile date (ISO, YYYY-MM-DD or DD/MM/YYYY); null if unknown.
  int? _daysUntil(dynamic value) {
    final v = value?.toString().trim() ?? '';
    if (v.isEmpty) return null;
    DateTime? d;
    final dmy = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(v);
    if (dmy != null) {
      d = DateTime(int.parse(dmy.group(3)!), int.parse(dmy.group(2)!),
          int.parse(dmy.group(1)!));
    } else {
      d = DateTime.tryParse(v)?.toLocal();
    }
    if (d == null) return null;
    final today = DateTime.now();
    return DateTime(d.year, d.month, d.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
  }

  /// Warns when the driving licence or vehicle card expires within 30 days.
  Widget _buildDocExpiryBanner() {
    final docs = <(String, int)>[];
    for (final (field, label) in const [
      ('expiryDateLicense', 'Driving licence'),
      ('expiryDateVehicleCard', 'Vehicle card'),
    ]) {
      final days = _daysUntil(_profile?[field]);
      if (days != null && days <= 30) docs.add((label, days));
    }
    if (docs.isEmpty) return const SizedBox.shrink();
    final expired = docs.any((d) => d.$2 < 0);
    final color = expired ? const Color(0xFFE53935) : const Color(0xFFFFB800);
    final text = docs
        .map((d) => d.$2 < 0
            ? '${d.$1} expired'
            : d.$2 == 0
                ? '${d.$1} expires today'
                : '${d.$1} expires in ${d.$2} day${d.$2 == 1 ? '' : 's'}')
        .join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Material(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/documents'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.badge_outlined, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('$text. Tap to upload the renewed copy.',
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

  Widget _buildChecklistCard() {
    if (_myRoutes.isEmpty) return const SizedBox.shrink();
    final today = ref.watch(todayChecklistProvider);
    return today.maybeWhen(
      data: (t) {
        final done = t.done;
        final color = !done
            ? (t.required ? const Color(0xFFE53935) : const Color(0xFFFFB800))
            : (t.allOk ? const Color(0xFF27AE60) : const Color(0xFFFFB800));
        final title = !done
            ? 'Daily van check not done'
            : (t.allOk ? 'Van check done' : 'Van check done — issues reported');
        final subtitle = !done
            ? (t.required
                ? 'Required before you can start a trip'
                : 'Takes less than a minute')
            : 'Tap to update';
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                await context.push<bool>(AppRoutes.checklist);
                if (!mounted) return;
                ref.invalidate(todayChecklistProvider);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.6)),
                ),
                child: Row(
                  children: [
                    Icon(done ? Icons.fact_check : Icons.checklist,
                        color: color),
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
      },
      // Hidden while loading or if the backend doesn't support it yet.
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    final passengers = (route['passengers'] as List?) ?? [];
    final tripStarted = route['TripStarted'] == true;
    // Backend stores startTime as a proper UTC instant — must convert to
    // local time before reading hour/minute, otherwise this shows the
    // wrong clock time (this was the bug behind the "15:00 instead of
    // 8:00 AM" display).
    final startTimeRaw = route['startTime'] != null
        ? DateTime.tryParse(route['startTime'].toString())?.toLocal()
        : null;
    final startTimeText =
        startTimeRaw != null ? _formatTime12Hour(startTimeRaw) : '—';

    // Mirrors the backend's 1-hour start window so the driver understands
    // *why* the button might be disabled, instead of it just failing silently.
    bool withinWindow = true;
    if (startTimeRaw != null) {
      final now = DateTime.now();
      final scheduledToday = DateTime(
          now.year, now.month, now.day, startTimeRaw.hour, startTimeRaw.minute);
      final windowEnd = scheduledToday.add(const Duration(hours: 1));
      withinWindow = !now.isBefore(scheduledToday) && !now.isAfter(windowEnd);
    }

    final isStartingThis =
        _startingRouteId && _startingRoute == route['routeId']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route['routeTitle'] ?? 'Route',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tripStarted
                      ? const Color(0xFF27AE60).withOpacity(0.1)
                      : const Color(0xFFFFB800).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tripStarted ? 'In Progress' : 'Not Started',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: tripStarted
                        ? const Color(0xFF27AE60)
                        : const Color(0xFFB8860B),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_bus_outlined,
                      size: 14, color: Color(0xFF8A94A6)),
                  const SizedBox(width: 4),
                  Text(
                    route['vehicleNumber'] ?? '—',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A94A6),
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: Color(0xFF8A94A6)),
                  const SizedBox(width: 4),
                  Text(
                    startTimeText,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A94A6),
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    route['tripType'] == 'drop'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: 14,
                    color: const Color(0xFF8A94A6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    route['tripType'] == 'drop' ? 'Drop' : 'Pick Up',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A94A6),
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Passengers (${passengers.length})',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          if (passengers.isEmpty)
            const Text(
              'No students on this route yet.',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8A94A6),
                  fontFamily: 'Poppins'),
            )
          else
            Column(
              children: passengers.map<Widget>((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            const Color(0xFF1B2B6B).withOpacity(0.1),
                        backgroundImage: (p['image'] != null &&
                                p['image'].toString().isNotEmpty)
                            ? NetworkImage(p['image'])
                            : null,
                        child: (p['image'] == null ||
                                p['image'].toString().isEmpty)
                            ? Text(
                                (p['fullname'] ?? '?')
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF1B2B6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p['fullname'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      if (p['grade'] != null)
                        Text(
                          'Grade ${p['grade']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8A94A6),
                            fontFamily: 'Poppins',
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          if (!tripStarted) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: (isStartingThis || !withinWindow)
                    ? null
                    : () => _startTripFromRoute(route),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2B6B),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF8A94A6).withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isStartingThis
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        withinWindow
                            ? 'Start Trip'
                            : 'Available at $startTimeText',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  final tripDetails = route['tripDetails'];
                  if (tripDetails == null) return;
                  final enriched = {
                    ...Map<String, dynamic>.from(tripDetails),
                    'schoolRoute': route['routeTitle'],
                  };
                  context.go('/trip', extra: enriched);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B2B6B),
                  side: const BorderSide(color: Color(0xFF1B2B6B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue Trip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Expanded(
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
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D4099), Color(0xFF1B2B6B)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1B2B6B).withOpacity(0.1),
                  const Color(0xFF2D4099).withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_outlined,
                size: 44, color: Color(0xFF1B2B6B)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Trip Today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No active trips have been assigned\nto you today. Check back later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: const Color(0xFFFFB800).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Color(0xFFFFB800), size: 16),
                SizedBox(width: 6),
                Text(
                  'You\'ll be notified when assigned',
                  style: TextStyle(
                    color: Color(0xFFFFB800),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    final String tripName = trip['tripName'] ??
        trip['name'] ??
        trip['schoolRoute'] ??
        'School Trip';

    // The Trip schema stores these nested/differently than what was
    // guessed here before (trip['date'], trip['tripDate'], trip['shift']
    // don't exist at all — hence the permanent "—" placeholders).
    final createdAt = trip['createdAt'] != null
        ? DateTime.tryParse(trip['createdAt'].toString())?.toLocal()
        : null;
    final String date = createdAt != null
        ? '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}'
        : '—';

    final tripStartRaw =
        trip['tripStart'] is Map ? trip['tripStart']['startTime'] : null;
    final startTimeParsed = tripStartRaw != null
        ? DateTime.tryParse(tripStartRaw.toString())?.toLocal()
        : null;
    final String startTime =
        startTimeParsed != null ? _formatTime12Hour(startTimeParsed) : '—';

    final String shift = (trip['type'] ?? '').toString().toLowerCase() == 'drop'
        ? 'Drop Off'
        : 'Pick Up';

    final String status = trip['status'] ?? 'pending';
    final bool isActive = status.toLowerCase() == 'active' ||
        status.toLowerCase() == 'ongoing' ||
        status.toLowerCase() == 'start';
    final bool isCompleted =
        status.toLowerCase() == 'end' || status.toLowerCase() == 'completed';

    Color statusColor = const Color(0xFFFFB800);
    String statusText = 'Starting';
    if (isActive) {
      statusColor = const Color(0xFF27AE60);
      statusText = 'Active';
    } else if (isCompleted) {
      statusColor = const Color(0xFF8A94A6);
      statusText = 'Completed';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Colored top bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCompleted
                    ? [const Color(0xFF8A94A6), const Color(0xFF8A94A6)]
                    : isActive
                        ? [const Color(0xFF27AE60), const Color(0xFF2ECC71)]
                        : [const Color(0xFF1B2B6B), const Color(0xFF2D4099)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B2B6B), Color(0xFF2D4099)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_bus,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tripName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(Icons.calendar_today_outlined, date),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.wb_sunny_outlined, shift),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.access_time, startTime),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isCompleted
                        ? null
                        : () => context.go('/trip', extra: trip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      foregroundColor: const Color(0xFF1B2B6B),
                      disabledBackgroundColor:
                          const Color(0xFF8A94A6).withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isCompleted ? 'Completed' : 'View Trip',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: isCompleted
                                ? const Color(0xFF8A94A6)
                                : const Color(0xFF1B2B6B),
                          ),
                        ),
                        if (!isCompleted) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              size: 18, color: Color(0xFF1B2B6B)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF1B2B6B)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF1A1A2E),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1B2B6B),
        unselectedItemColor: const Color(0xFF8A94A6),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontFamily: 'Poppins',
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
