import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_errors.dart';
import '../../../core/network/api_service.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/sync_queue.dart';
import '../../trip/application/kid_absence_events.dart';
import '../../trip/application/trip_tracking.dart';
import '../../trip/data/models/active_trip.dart';
import '../../passengers/data/models/kid_absence_event.dart';
import '../kid_status.dart';
import '../stop_api.dart';
import '../../../core/router/app_routes.dart';
import '../../chat/data/chat_repository.dart';

class PassengersScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> trip;
  const PassengersScreen({super.key, required this.trip});

  @override
  ConsumerState<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends ConsumerState<PassengersScreen> {
  List<dynamic> _passengers = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _pickedCount = 0;
  Map<String, String> _pendingSync = const {};
  final Set<String> _busyKidIds = {};
  StreamSubscription<void>? _syncedSub;
  StreamSubscription<KidAbsenceEvent>? _absenceSub;

  /// Refreshes the "waiting 1:23" timers on cards.
  Timer? _ticker;
  final Set<String> _stopBusy = {};

  /// How long the driver should wait before "move on" is offered.
  static const _waitBeforeNoShow = Duration(minutes: 2);

  String? get _tripId {
    final fromRoute = ActiveTrip.fromJson(widget.trip).id;
    return fromRoute.isNotEmpty
        ? fromRoute
        : ref.read(tripTrackingProvider).tripId;
  }

  @override
  void initState() {
    super.initState();
    _loadPassengers();
    // When queued picks/drops reach the server, reload real statuses.
    _syncedSub =
        ref.read(syncQueueProvider).onSynced.listen((_) => _loadPassengers());
    // A parent marked a child absent (or cancelled it) during the trip.
    _absenceSub = ref.read(kidAbsenceBusProvider).stream.listen((e) {
      _loadPassengers();
      final name = e.fullname.isEmpty ? 'A student' : e.fullname;
      _showSnack(
          e.cancelled
              ? '$name will ride today after all.'
              : '$name is absent today (parent informed).',
          const Color(0xFF1B2B6B));
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted &&
          _passengers.any((p) => p is Map && p['waitingSince'] != null)) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _syncedSub?.cancel();
    _absenceSub?.cancel();
    _ticker?.cancel();
    super.dispose();
  }

  void _recount() {
    _pendingSync = ref.read(syncQueueProvider).pendingKidStatuses(_tripId);
    _pickedCount = _passengers
        .where((p) => KidStatus.isPickedOrDropped(
            KidStatus.of(p as Map, pendingSync: _pendingSync)))
        .length;
  }

  Future<void> _loadPassengers() async {
    setState(() => _hasError = false);
    try {
      final response = await ApiService.get('/Route/getMergedActivePassengers');
      if (response.statusCode == 200 && mounted) {
        final raw = response.data;
        final data = raw['data'] ?? raw ?? [];
        setState(() {
          _passengers = _sorted(data is List ? data : []);
          _recount();
        });
      }
    } catch (e) {
      // Offline: keep the list we were given by the trip screen so the
      // driver can still mark picks/drops.
      if (mounted) {
        setState(() {
          if (_passengers.isEmpty && widget.trip['passengers'] is List) {
            _passengers = List.of(widget.trip['passengers'] as List);
          }
          _recount();
          _hasError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Riders first; absent and no-show kids at the bottom.
  List<dynamic> _sorted(List<dynamic> list) {
    int rank(dynamic p) =>
        p is Map && (p['absent'] == true || p['noShow'] == true) ? 1 : 0;
    final indexed = list.asMap().entries.toList()
      ..sort((a, b) {
        final r = rank(a.value).compareTo(rank(b.value));
        return r != 0 ? r : a.key.compareTo(b.key);
      });
    return indexed.map((e) => e.value).toList();
  }

  Future<void> _arrivedAtStop(Map<String, dynamic> kid) async {
    final kidId = KidStatus.idOf(kid);
    final tripId = (kid['tripId'] ?? _tripId)?.toString();
    if (kidId == null || tripId == null || _stopBusy.contains(kidId)) return;
    setState(() => _stopBusy.add(kidId));
    try {
      final at = await StopApi.arrived(tripId, kidId);
      if (!mounted) return;
      setState(() => kid['waitingSince'] = at.toIso8601String());
      _showSnack(
          'Parent told the van is at the stop.', const Color(0xFF27AE60));
    } catch (e) {
      _showSnack(ApiErrors.message(e, fallback: 'Could not notify the parent.'),
          const Color(0xFFFF4B4B));
    } finally {
      if (mounted) setState(() => _stopBusy.remove(kidId));
    }
  }

  Future<void> _markNoShow(Map<String, dynamic> kid) async {
    final kidId = KidStatus.idOf(kid);
    final tripId = (kid['tripId'] ?? _tripId)?.toString();
    if (kidId == null || tripId == null || _stopBusy.contains(kidId)) return;
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${kid['fullname'] ?? 'Student'} not at stop?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('The parent will be told the van moved on.'),
            const SizedBox(height: 8),
            TextField(
              controller: note,
              maxLength: 200,
              decoration: const InputDecoration(hintText: 'Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep waiting')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Move on')),
        ],
      ),
    );
    final text = note.text;
    note.dispose();
    if (ok != true || !mounted) return;
    setState(() => _stopBusy.add(kidId));
    try {
      await StopApi.noShow(tripId, kidId, note: text);
      if (!mounted) return;
      setState(() {
        kid['noShow'] = true;
        _passengers = _sorted(_passengers);
      });
    } catch (e) {
      _showSnack(
          ApiErrors.message(e, fallback: 'Could not mark as not at stop.'),
          const Color(0xFFFF4B4B));
    } finally {
      if (mounted) setState(() => _stopBusy.remove(kidId));
    }
  }

  /// Small row under the card: absent / no-show / at-stop / waiting timer.
  Widget? _buildStopRow(
      Map<String, dynamic> kid, bool isPicked, bool isDropped) {
    Widget chip(IconData icon, String text, Color color) => Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600)),
            ),
          ],
        );

    if (kid['absent'] == true && !isPicked && !isDropped) {
      final note = kid['absenceNote']?.toString();
      return chip(
          Icons.event_busy,
          'Absent today${note != null && note.isNotEmpty ? ' — $note' : ' (parent informed)'}',
          const Color(0xFF8A94A6));
    }
    if (kid['noShow'] == true && !isPicked) {
      return chip(Icons.directions_walk, 'Not at stop — moved on',
          const Color(0xFFE53935));
    }
    if (isDropped) return null;

    final tripType = kid['tripType']?.toString();
    final relevant = tripType == 'drop' ? isPicked : !isPicked;
    if (!relevant) return null;

    final kidId = KidStatus.idOf(kid) ?? '';
    final busy = _stopBusy.contains(kidId);
    final since =
        DateTime.tryParse(kid['waitingSince']?.toString() ?? '')?.toLocal();
    if (since == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: busy ? null : () => _arrivedAtStop(kid),
          icon: const Icon(Icons.where_to_vote_outlined, size: 18),
          label: Text(tripType == 'drop'
              ? 'At home — tell parent'
              : 'At stop — tell parent'),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              foregroundColor: const Color(0xFF1B2B6B)),
        ),
      );
    }

    final waited = DateTime.now().difference(since);
    final mm = waited.inMinutes;
    final ss = (waited.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      children: [
        Expanded(
            child: chip(Icons.timer_outlined, 'Waiting $mm:$ss',
                const Color(0xFFFFB800))),
        if (tripType != 'drop' && waited >= _waitBeforeNoShow)
          TextButton(
            onPressed: busy ? null : () => _markNoShow(kid),
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
                visualDensity: VisualDensity.compact),
            child: const Text('Not here — move on'),
          ),
      ],
    );
  }

  Future<void> _pickStudent(Map<String, dynamic> kid) async {
    if (kid['absent'] == true) {
      final pick = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Marked absent'),
          content: Text(
              '${kid['fullname'] ?? 'This student'}\'s parent said they are absent today. Pick up anyway?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Pick up')),
          ],
        ),
      );
      if (pick != true || !mounted) return;
    }
    final kidId = KidStatus.idOf(kid);
    final tripId = (kid['tripId'] ?? _tripId)?.toString();
    if (kidId == null || tripId == null || _busyKidIds.contains(kidId)) return;
    setState(() => _busyKidIds.add(kidId));
    try {
      final outcome = await ref.read(syncQueueProvider).submit(
            kind: SyncKind.pick,
            path: '/trips/pickStudent',
            body: {'tripId': tripId, 'kidId': kidId},
            tripId: tripId,
            kidId: kidId,
          );
      final name = kid['fullname'] ?? 'Kid';
      if (outcome == SubmitOutcome.sent) {
        await _loadPassengers();
        _showSnack('$name picked up!', const Color(0xFF27AE60));
      } else {
        if (mounted) setState(_recount);
        _showSnack('$name picked up — saved offline, will sync automatically.',
            const Color(0xFFFFB800));
      }
    } catch (e) {
      _showSnack(ApiErrors.message(e, fallback: 'Failed to pick student'),
          const Color(0xFFFF4B4B));
    } finally {
      if (mounted) setState(() => _busyKidIds.remove(kidId));
    }
  }

  Future<void> _dropStudent(Map<String, dynamic> kid) async {
    final kidId = KidStatus.idOf(kid);
    final tripId = (kid['tripId'] ?? _tripId)?.toString();
    if (kidId == null || tripId == null || _busyKidIds.contains(kidId)) return;
    setState(() => _busyKidIds.add(kidId));
    try {
      // Real GPS only. The old code fell back to a fixed Karachi coordinate,
      // which wrote a fake point into the trip's location history.
      final position =
          await ref.read(tripTrackingProvider.notifier).currentPosition();
      if (position == null) {
        _showSnack(
            'Could not get your GPS location. Turn on location and try again.',
            const Color(0xFFFF4B4B));
        return;
      }
      final outcome = await ref.read(syncQueueProvider).submit(
            kind: SyncKind.drop,
            path: '/trips/dropStudentForHome',
            body: {
              'tripId': tripId,
              'kidId': kidId,
              'lat': position.lat,
              'long': position.lng,
            },
            tripId: tripId,
            kidId: kidId,
          );
      final name = kid['fullname'] ?? 'Kid';
      if (outcome == SubmitOutcome.sent) {
        await _loadPassengers();
        _showSnack('$name dropped off!', const Color(0xFF1B2B6B));
      } else {
        if (mounted) setState(_recount);
        _showSnack(
            '$name dropped off — saved offline, will sync automatically.',
            const Color(0xFFFFB800));
      }
    } catch (e) {
      _showSnack(
          ApiErrors.message(e,
              fallback:
                  'Failed to drop off ${kid['fullname'] ?? 'kid'}. Please try again.'),
          const Color(0xFFFF4B4B));
    } finally {
      if (mounted) setState(() => _busyKidIds.remove(kidId));
    }
  }

  Future<void> _messageParent(String kidId) async {
    try {
      final conversation = await ref.read(chatRepositoryProvider).start(kidId);
      if (mounted) {
        await context.push(AppRoutes.chatOf(conversation.id),
            extra: conversation);
      }
    } catch (e) {
      _showSnack(ApiErrors.message(e, fallback: 'Could not open chat.'),
          const Color(0xFFFF4B4B));
    }
  }

  void _showSnack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        const Spacer(),
                        IconButton(
                          tooltip: 'Scan student card',
                          icon: const Icon(Icons.qr_code_scanner,
                              color: Colors.white),
                          onPressed: () async {
                            await context.push('/scan');
                            if (mounted) _loadPassengers();
                          },
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
                        _buildHeaderStat('Remaining',
                            (total - _pickedCount).toString(), Colors.white70),
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
                    child: CircularProgressIndicator(color: Color(0xFF1B2B6B)))
                : _hasError && _passengers.isEmpty
                    ? _buildErrorState()
                    : _passengers.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadPassengers,
                            color: const Color(0xFF1B2B6B),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _passengers.length,
                              itemBuilder: (context, index) {
                                return _buildPassengerCard(_passengers[index]);
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4B4B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded,
                size: 40, color: Color(0xFFFF4B4B)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Couldn\'t Load Passengers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your connection and try again',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPassengers,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Retry', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
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
    final String status = KidStatus.of(kid, pendingSync: _pendingSync);
    final bool isPicked = status == KidStatus.picked;
    final bool isDropped = status == KidStatus.dropped;
    final kidId = KidStatus.idOf(kid);
    final bool isUnsynced = kidId != null && _pendingSync.containsKey(kidId);
    final String schoolName =
        kid['school']?['schoolName'] ?? kid['schoolName'] ?? '—';
    final String distance = kid['distance'] ?? '—';
    final stopRow = _buildStopRow(kid, isPicked, isDropped);

    return Opacity(
      // Absent / no-show kids are dimmed so the driver's eye goes to riders.
      opacity: (kid['absent'] == true || kid['noShow'] == true) &&
              !isPicked &&
              !isDropped
          ? 0.6
          : 1,
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  // Avatar — tap to view full profile (address, parent contact,
                  // alternate phone). This screen already existed and worked
                  // correctly, but was completely unreachable from anywhere.
                  GestureDetector(
                    onTap: () => context.push('/kid-profile', extra: kid),
                    child: Container(
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
                  ),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            if (isUnsynced) ...[
                              const SizedBox(width: 6),
                              const Tooltip(
                                message: 'Saved offline — waiting to sync',
                                child: Icon(Icons.cloud_upload_outlined,
                                    size: 16, color: Color(0xFFFFB800)),
                              ),
                            ],
                            if (kidId != null)
                              IconButton(
                                tooltip: 'Message parent',
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.chat_bubble_outline,
                                    size: 18, color: Color(0xFF1B2B6B)),
                                onPressed: () => _messageParent(kidId),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 12, color: Color(0xFF8A94A6)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                distance != '—' ? '$distance Away' : schoolName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8A94A6),
                                  fontFamily: 'Poppins',
                                ),
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
              if (stopRow != null) ...[
                const SizedBox(height: 6),
                stopRow,
              ],
            ],
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFF1B2B6B).withOpacity(0.3)),
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
          border: Border.all(color: const Color(0xFFFFB800).withOpacity(0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.arrow_upward, size: 14, color: Color(0xFFFFB800)),
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
