import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_service.dart';
import '../../alerts/screens/alerts_screen.dart';
import '../../profile/screens/profile_screen.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadProfile(), _loadTrips(), _loadMyRoutes()]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadMyRoutes() async {
    try {
      final response = await ApiService.get('/route/getAssignedTripByDriver');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw['data'];
        setState(() => _myRoutes = data is List ? data : []);
      }
    } catch (e) {
      // No van assigned / no routes today / driver inactive — all handled
      // as "nothing to show" rather than a crash. The empty state below
      // covers this gracefully.
      setState(() => _myRoutes = []);
    }
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200) {
        final raw = response.data;
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove(AppConstants.tokenKey);
              if (mounted) context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B4B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout',
                style:
                    TextStyle(color: Colors.white, fontFamily: 'Poppins')),
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
      color: const Color(0xFF1B3B69),
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
                  colors: [Color(0xFF1B3B69), Color(0xFF2D4099)],
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
                                  color: const Color(0xFFFEC610),
                                  width: 2.5),
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
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 22),
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
                                  color: Color(0xFFFEC610), size: 16),
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
                          _buildStatChip(
                              Icons.people_outline,
                              '${_totalPassengerCount()}',
                              'Passengers'),
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
                          color: const Color(0xFF1B3B69).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_trips.length} trips',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1B3B69),
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
                              color: Color(0xFF1B3B69)))
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
    }
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
    final startTimeText = startTimeRaw != null
        ? _formatTime12Hour(startTimeRaw)
        : '—';

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
                      : const Color(0xFFFEC610).withOpacity(0.15),
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
                  Icon(Icons.directions_bus_outlined,
                      size: 14, color: const Color(0xFF8A94A6)),
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
                            const Color(0xFF1B3B69).withOpacity(0.1),
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
                                  color: Color(0xFF1B3B69),
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
                  backgroundColor: const Color(0xFF1B3B69),
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
                  foregroundColor: const Color(0xFF1B3B69),
                  side: const BorderSide(color: Color(0xFF1B3B69)),
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
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFFEC610), size: 20),
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
          colors: [Color(0xFF2D4099), Color(0xFF1B3B69)],
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
                  const Color(0xFF1B3B69).withOpacity(0.1),
                  const Color(0xFF2D4099).withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_outlined,
                size: 44, color: Color(0xFF1B3B69)),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEC610).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: const Color(0xFFFEC610).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline,
                    color: Color(0xFFFEC610), size: 16),
                SizedBox(width: 6),
                Text(
                  'You\'ll be notified when assigned',
                  style: TextStyle(
                    color: Color(0xFFFEC610),
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
    final String tripName =
        trip['tripName'] ?? trip['name'] ?? trip['schoolRoute'] ?? 'School Trip';

    // The Trip schema stores these nested/differently than what was
    // guessed here before (trip['date'], trip['tripDate'], trip['shift']
    // don't exist at all — hence the permanent "—" placeholders).
    final createdAt = trip['createdAt'] != null
        ? DateTime.tryParse(trip['createdAt'].toString())?.toLocal()
        : null;
    final String date = createdAt != null
        ? '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}'
        : '—';

    final tripStartRaw = trip['tripStart'] is Map ? trip['tripStart']['startTime'] : null;
    final startTimeParsed = tripStartRaw != null
        ? DateTime.tryParse(tripStartRaw.toString())?.toLocal()
        : null;
    final String startTime =
        startTimeParsed != null ? _formatTime12Hour(startTimeParsed) : '—';

    final String shift =
        (trip['type'] ?? '').toString().toLowerCase() == 'drop'
            ? 'Drop Off'
            : 'Pick Up';

    final String status = trip['status'] ?? 'pending';
    final bool isActive = status.toLowerCase() == 'active' ||
        status.toLowerCase() == 'ongoing' ||
        status.toLowerCase() == 'start';
    final bool isCompleted = status.toLowerCase() == 'end' ||
        status.toLowerCase() == 'completed';

    Color statusColor = const Color(0xFFFEC610);
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
                    ? [
                        const Color(0xFF8A94A6),
                        const Color(0xFF8A94A6)
                      ]
                    : isActive
                        ? [
                            const Color(0xFF27AE60),
                            const Color(0xFF2ECC71)
                          ]
                        : [
                            const Color(0xFF1B3B69),
                            const Color(0xFF2D4099)
                          ],
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
                          colors: [Color(0xFF1B3B69), Color(0xFF2D4099)],
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
                    _buildInfoChip(
                        Icons.calendar_today_outlined, date),
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
                      backgroundColor: const Color(0xFFFEC610),
                      foregroundColor: const Color(0xFF1B3B69),
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
                                : const Color(0xFF1B3B69),
                          ),
                        ),
                        if (!isCompleted) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              size: 18, color: Color(0xFF1B3B69)),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF1B3B69)),
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
        selectedItemColor: const Color(0xFF1B3B69),
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