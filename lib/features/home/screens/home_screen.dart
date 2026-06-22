import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _profile;
  List<dynamic> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadProfile(), _loadTrips()]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200) {
        final raw = response.data;
        setState(() => _profile = raw['data'] ?? raw);
      }
    } catch (e) {}
  }

  Future<void> _loadTrips() async {
    try {
      final response = await ApiService.get('/Trip/getDriverTrips');
      if (response.statusCode == 200) {
        final raw = response.data;
        setState(() => _trips = raw['data'] ?? raw ?? []);
      }
    } catch (e) {}
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        return _buildAlertsPlaceholder();
      case 2:
        return _buildProfilePlaceholder();
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
                          // Notification bell
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
                          // Logout
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
                    const SizedBox(height: 24),

                    // Stats Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      child: Row(
                        children: [
                          _buildStatChip(
                              Icons.directions_bus_outlined,
                              '${_trips.length}',
                              'Trips Today'),
                          const SizedBox(width: 12),
                          _buildStatChip(
                              Icons.people_outline,
                              _trips.isEmpty ? '0' : '—',
                              'Passengers'),
                          const SizedBox(width: 12),
                          _buildStatChip(
                              Icons.check_circle_outline,
                              _trips.where((t) =>
                                          (t['status'] ?? '')
                                              .toString()
                                              .toLowerCase() ==
                                          'completed')
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

            // Today's Trips Section
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
              border: Border.all(
                  color: const Color(0xFFFFB800).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline,
                    color: Color(0xFFFFB800), size: 16),
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
    final String tripName =
        trip['tripName'] ?? trip['name'] ?? 'School Trip';
    final String date = trip['date'] ?? trip['tripDate'] ?? '—';
    final String shift = trip['shift'] ?? 'Morning';
    final String startTime =
        trip['startTime'] ?? trip['tripStartTime'] ?? '—';
    final String status = trip['status'] ?? 'pending';
    final bool isActive = status.toLowerCase() == 'active' ||
        status.toLowerCase() == 'ongoing';
    final bool isCompleted = status.toLowerCase() == 'completed';

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
                        ? [
                            const Color(0xFF27AE60),
                            const Color(0xFF2ECC71)
                          ]
                        : [
                            const Color(0xFF1B2B6B),
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

                // Info chips
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

                // View Trip Button
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

  Widget _buildAlertsPlaceholder() {
    return const Center(
      child: Text('Alerts Coming Soon',
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1B2B6B),
              fontFamily: 'Poppins')),
    );
  }

  Widget _buildProfilePlaceholder() {
    return const Center(
      child: Text('Profile Coming Soon',
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1B2B6B),
              fontFamily: 'Poppins')),
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