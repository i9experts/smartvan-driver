import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_service.dart';

class PassengersScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> trip;
  const PassengersScreen({super.key, required this.trip});

  @override
  ConsumerState<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends ConsumerState<PassengersScreen> {
  List<dynamic> _passengers = [];
  bool _isLoading = true;
  int _pickedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPassengers();
  }

  Future<void> _loadPassengers() async {
    try {
      final response = await ApiService.get('/kid/getKids');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw['data'] ?? raw ?? [];
        setState(() {
          _passengers = data is List ? data : [];
          _pickedCount = _passengers
              .where((p) =>
                  (p['status'] ?? '').toString().toLowerCase() == 'picked')
              .length;
        });
      }
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickStudent(Map<String, dynamic> kid) async {
    try {
      final tripId = widget.trip['_id'] ?? widget.trip['id'];
      final kidId = kid['_id'] ?? kid['id'];
      await ApiService.post('/trips/pickStudent', {
        'tripId': tripId,
        'kidId': kidId,
      });
      await _loadPassengers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${kid['fullname'] ?? 'Kid'} picked up!'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to pick student'),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _dropStudent(Map<String, dynamic> kid) async {
    try {
      final tripId = widget.trip['_id'] ?? widget.trip['id'];
      final kidId = kid['_id'] ?? kid['id'];
      await ApiService.post('/trips/dropStudentForHome', {
        'tripId': tripId,
        'kidId': kidId,
        'lat': 24.8607,
        'long': 67.0011,
      });
      await _loadPassengers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${kid['fullname'] ?? 'Kid'} dropped off!'),
            backgroundColor: const Color(0xFF1B2B6B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final String tripName =
        widget.trip['tripName'] ?? widget.trip['name'] ?? 'Trip';
    final int total = _passengers.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B2B6B), Color(0xFF2D4099)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Passengers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Stats row
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        _buildHeaderStat(
                            'Total', total.toString(), const Color(0xFFFFB800)),
                        const SizedBox(width: 12),
                        _buildHeaderStat('Picked', _pickedCount.toString(),
                            const Color(0xFF27AE60)),
                        const SizedBox(width: 12),
                        _buildHeaderStat(
                            'Remaining',
                            (total - _pickedCount).toString(),
                            Colors.white70),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Passengers List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1B2B6B)))
                : _passengers.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadPassengers,
                        color: const Color(0xFF1B2B6B),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _passengers.length,
                          itemBuilder: (context, index) {
                            return _buildPassengerCard(
                                _passengers[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B6B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline,
                size: 40, color: Color(0xFF1B2B6B)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Passengers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No students assigned to this trip',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(Map<String, dynamic> kid) {
    final String name = kid['fullname'] ?? kid['name'] ?? 'Unknown';
    final String? image = kid['image'] ?? kid['profileImage'];
    final String status = kid['tripStatus'] ?? kid['status'] ?? 'pending';
    final bool isPicked = status.toLowerCase() == 'picked';
    final bool isDropped = status.toLowerCase() == 'dropped';
    final String schoolName =
        kid['school']?['schoolName'] ?? kid['schoolName'] ?? '—';
    final String distance = kid['distance'] ?? '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPicked
                      ? const Color(0xFF27AE60)
                      : isDropped
                          ? const Color(0xFF1B2B6B)
                          : const Color(0xFFEAECF0),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: image != null
                    ? Image.network(image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildAvatarFallback(name))
                    : _buildAvatarFallback(name),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Color(0xFF8A94A6)),
                      const SizedBox(width: 4),
                      Text(
                        distance != '—' ? '$distance Away' : schoolName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Button
            _buildActionButton(kid, isPicked, isDropped),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      Map<String, dynamic> kid, bool isPicked, bool isDropped) {
    if (isDropped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF8A94A6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Dropped',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A94A6),
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    if (isPicked) {
      return Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Picked',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF27AE60),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _dropStudent(kid),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF1B2B6B).withOpacity(0.3)),
              ),
              child: const Text(
                'Drop',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B2B6B),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _pickStudent(kid),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB800).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFFFFB800).withOpacity(0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.arrow_upward,
                size: 14, color: Color(0xFFFFB800)),
            SizedBox(width: 4),
            Text(
              'Pick Up',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFB800),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2B6B).withOpacity(0.7),
            const Color(0xFF2D4099).withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'K',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}