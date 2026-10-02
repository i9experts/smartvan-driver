import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/network/api_errors.dart';
import '../../../core/network/api_service.dart';
import '../../../core/sync/sync_queue.dart';
import '../../passengers/kid_status.dart';
import '../services/trip_tracking_service.dart';

class TripScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> trip;
  const TripScreen({super.key, required this.trip});

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> {
  static const LatLng _fallbackCenter = LatLng(24.8607, 67.0011);

  GoogleMapController? _mapController;
  // Every way of reaching this screen means a Trip document already exists
  // with status 'ongoing' (created via "Start Trip" on the home screen).
  final bool _isTripStarted = true;
  final bool _isStartingTrip = false;
  bool _isEndingTrip = false;
  List<dynamic> _passengers = [];
  int _pickedCount = 0;
  int _totalPassengers = 0;
  Map<String, dynamic>? _profile;
  StreamSubscription<void>? _syncedSub;

  /// Trip details: the route's extra if given, otherwise whatever the
  /// tracking service is holding (e.g. after resuming a killed app).
  Map<String, dynamic> get _trip =>
      widget.trip.isNotEmpty ? widget.trip : (ref.read(tripTrackingProvider).trip ?? {});

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadPassengers();
    _syncedSub = SyncQueue.instance.onSynced.listen((_) => _loadPassengers());
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTracking());
  }

  @override
  void dispose() {
    // Tracking intentionally keeps running — it belongs to the trip, not to
    // this screen. It stops only when the trip is ended.
    _syncedSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _startTracking() async {
    final trip = _trip;
    if (trip.isEmpty) return;
    final result = await ref.read(tripTrackingProvider.notifier).start(trip);
    if (!mounted) return;
    final message = switch (result) {
      TrackingStartResult.locationServiceOff =>
        'Please enable location services to share your trip.',
      TrackingStartResult.permissionDenied =>
        'Location permission is needed to share your trip with parents.',
      TrackingStartResult.permissionDeniedForever =>
        'Location permission permanently denied. Enable it in app settings.',
      _ => null,
    };
    if (message != null) _showSnack(message, isError: true);
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ApiService.get('/auth/getProfile');
      if (response.statusCode == 200 && mounted) {
        final raw = response.data;
        setState(() => _profile = raw['data'] ?? raw);
      }
    } catch (e) {
      debugPrint('Failed to load driver profile: $e');
    }
  }

  Future<void> _loadPassengers() async {
    try {
      // /kid/getKids returns each kid's account-verification status, not
      // their pickup state for this trip — that only lives on
      // /Route/getMergedActivePassengers (same endpoint the Passengers
      // screen uses), so this has to match it to get a real picked count.
      final response =
          await ApiService.get('/Route/getMergedActivePassengers');
      if (response.statusCode == 200 && mounted) {
        final raw = response.data;
        final data = raw['data'] ?? raw ?? [];
        final list = data is List ? data : [];
        final pending = SyncQueue.instance
            .pendingKidStatuses(TripTrackingState.tripIdOf(_trip));
        setState(() {
          _passengers = list;
          _totalPassengers = list.length;
          _pickedCount = list
              .where((p) => KidStatus.isPickedOrDropped(
                  KidStatus.of(p as Map, pendingSync: pending)))
              .length;
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnack(ApiErrors.message(e, fallback: 'Failed to load passengers'),
            isError: true);
      }
    }
  }

  void _onPositionChanged(LatLng? position) {
    if (position == null) return;
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  Set<Marker> _markersFor(LatLng position) => {
        Marker(
          markerId: const MarkerId('driver'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      };

  Future<void> _endTrip() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('End Trip',
            style: TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to end this trip?',
            style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('End Trip',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isEndingTrip = true);
    try {
      await ref.read(tripTrackingProvider.notifier).endTrip();
      if (!mounted) return;
      _showSnack('Trip ended successfully!', color: const Color(0xFF27AE60));
      context.go('/home');
    } on PendingSyncException catch (e) {
      if (mounted) {
        setState(() => _isEndingTrip = false);
        _showSnack(e.toString(), isError: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isEndingTrip = false);
        _showSnack(ApiErrors.message(e, fallback: 'Failed to end trip.'),
            isError: true);
      }
    }
  }

  void _showSnack(String message, {bool isError = false, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            color ?? (isError ? const Color(0xFFFF4B4B) : const Color(0xFF1B2B6B)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSyncBanner(TripTrackingState tracking) {
    return ValueListenableBuilder<int>(
      valueListenable: SyncQueue.instance.pending,
      builder: (context, pending, _) {
        final warnings = <Widget>[];
        if (!tracking.isTracking) {
          warnings.add(_banner(
            Icons.location_off,
            'Location sharing is off — parents can\'t see the van.',
            const Color(0xFFFF4B4B),
            action: TextButton(
              onPressed: _startTracking,
              child: const Text('Turn on',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ));
        }
        if (pending > 0) {
          warnings.add(_banner(
            Icons.cloud_off,
            '$pending update${pending == 1 ? '' : 's'} saved offline — will sync automatically.',
            const Color(0xFFFFB800),
          ));
        }
        if (warnings.isEmpty) return const SizedBox.shrink();
        return Column(mainAxisSize: MainAxisSize.min, children: warnings);
      },
    );
  }

  Widget _banner(IconData icon, String text, Color color, {Widget? action}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(tripTrackingProvider);
    ref.listen<LatLng?>(
      tripTrackingProvider.select((s) => s.lastPosition),
      (_, next) => _onPositionChanged(next),
    );
    final driverPosition = tracking.lastPosition ?? _fallbackCenter;
    final bool isConnected = tracking.socketConnected;
    final trip = _trip;

    final String tripName =
        trip['tripName'] ?? trip['name'] ?? 'Morning Trip';
    final String shift = trip['shift'] ?? 'Morning';
    final String schoolRoute =
        trip['schoolRoute'] ?? trip['route'] ?? '—';
    final String driverName =
        _profile?['fullname'] ?? _profile?['name'] ?? 'Driver';

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
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => context.go('/home'),
                    ),
                    Expanded(
                      child: Text(
                        tripName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFF27AE60).withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isConnected
                              ? const Color(0xFF27AE60)
                              : Colors.white30,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? const Color(0xFF27AE60)
                                  : Colors.white30,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isConnected ? 'Live' : 'Offline',
                            style: TextStyle(
                              color: isConnected
                                  ? const Color(0xFF27AE60)
                                  : Colors.white54,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map + Bottom Card
          Expanded(
            child: Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: driverPosition,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) =>
                      _mapController = controller,
                  markers: _markersFor(driverPosition),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

                // Passengers button
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      await context.push('/passengers', extra: {
                        ...trip,
                        'passengers': _passengers,
                      });
                      // Refresh counts after picks/drops on that screen.
                      if (mounted) _loadPassengers();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people,
                              color: Color(0xFF1B2B6B), size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '$_totalPassengers Passengers',
                            style: const TextStyle(
                              color: Color(0xFF1B2B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Offline / location warnings
                Positioned(
                  top: 64,
                  left: 16,
                  right: 16,
                  child: _buildSyncBanner(tracking),
                ),

                // Bottom card
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1B2B6B),
                                    Color(0xFF2D4099)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driverName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A2E),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'School Route: $schoolRoute',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8A94A6),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B2B6B)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$_totalPassengers Pass.',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1B2B6B),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFEAECF0)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _buildTripStat(
                                Icons.calendar_today_outlined,
                                trip['date'] ?? '—',
                                'Date'),
                            _buildStatDivider(),
                            _buildTripStat(Icons.wb_sunny_outlined,
                                shift, 'Shift'),
                            _buildStatDivider(),
                            _buildTripStat(
                                Icons.people_outline,
                                '$_pickedCount/$_totalPassengers',
                                'Picked'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isEndingTrip ? null : _endTrip,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isTripStarted
                                  ? const Color(0xFF1B2B6B)
                                  : const Color(0xFFFFB800),
                              foregroundColor: _isTripStarted
                                  ? Colors.white
                                  : const Color(0xFF1B2B6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: _isStartingTrip || _isEndingTrip
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: _isTripStarted
                                          ? Colors.white
                                          : const Color(0xFF1B2B6B),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isTripStarted
                                            ? Icons.stop_circle_outlined
                                            : Icons.play_circle_outlined,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isTripStarted
                                            ? 'End Trip'
                                            : 'Start Trip',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward,
                                          size: 18),
                                    ],
                                  ),
                          ),
                        ),
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

  Widget _buildTripStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B2B6B), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8A94A6),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFFEAECF0),
    );
  }
}