import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../passengers/application/passengers_controller.dart';
import '../../../profile/application/driver_profile_provider.dart';
import '../../../safety/presentation/widgets/sos_button.dart';
import '../../application/active_trip_provider.dart';
import '../../application/end_trip_controller.dart';
import '../../application/trip_tracking.dart';
import '../../data/models/active_trip.dart';
import '../../data/models/geo_point.dart';
import '../widgets/kids_not_dropped_sheet.dart';
import '../widgets/trip_banners.dart';
import '../widgets/trip_bottom_card.dart';
import '../widgets/trip_header.dart';
import '../widgets/trip_map.dart';

/// The running trip: live map, passengers, scan, SOS and End Trip.
///
/// [tripId] comes from the route. [trip] is an optional already-known trip
/// (just started from Home); without it the trip is read from tracking or
/// from what was saved when the app was last closed.
class TripScreen extends ConsumerStatefulWidget {
  const TripScreen({super.key, required this.tripId, this.trip});

  final String tripId;
  final ActiveTrip? trip;

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> {
  static const _fallbackCenter = LatLng(24.8607, 67.0011);

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTracking());
  }

  @override
  void dispose() {
    // Tracking intentionally keeps running — it belongs to the trip, not to
    // this screen. It stops only when the trip is ended.
    _mapController?.dispose();
    super.dispose();
  }

  ActiveTrip? get _trip =>
      widget.trip ?? ref.read(activeTripForProvider(widget.tripId));

  Future<void> _startTracking() async {
    final trip = _trip;
    if (trip == null) return;
    final l10n = context.l10n;
    final result = await ref.read(tripTrackingProvider.notifier).start(trip);
    if (!mounted) return;
    final message = switch (result) {
      TrackingStartResult.locationServiceOff => l10n.tripLocationServicesOff,
      TrackingStartResult.permissionDenied => l10n.tripPermissionDenied,
      TrackingStartResult.permissionDeniedForever => l10n.tripPermissionForever,
      _ => null,
    };
    if (message != null) AppSnack.error(context, message);
  }

  Future<void> _endTrip() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.tripEndTrip,
            style: const TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text(l10n.tripEndConfirm,
            style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel,
                style: const TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.tripEndTrip,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _submitEnd();
  }

  Future<void> _submitEnd({bool forceEnd = false, String? note}) async {
    final l10n = context.l10n;
    final result = await ref
        .read(endTripControllerProvider.notifier)
        .end(forceEnd: forceEnd, note: note);
    if (!mounted) return;
    switch (result) {
      case TripEnded(:final forced):
        AppSnack.success(
            context, forced ? l10n.tripEndedForced : l10n.tripEndedOk);
        context.go(AppRoutes.home);
      case UnsyncedUpdates(:final count):
        AppSnack.error(context, l10n.tripPendingSync(count));
      case EndTripFailed(:final error):
        AppSnack.error(context, errorText(l10n, error, fallback: l10n.tripEndFailed));
      case KidsStillOnBoard(:final kids):
        final choice = await KidsNotDroppedSheet.show(context, kids);
        if (!mounted) return;
        switch (choice) {
          case OpenPassengersChoice():
            await context.push(AppRoutes.passengersOf(widget.tripId));
            // Refresh counts after picks/drops on that screen.
            if (mounted) {
              ref
                  .read(passengersControllerProvider(widget.tripId).notifier)
                  .refresh();
            }
          case ForceEndChoice(:final note):
            await _submitEnd(forceEnd: true, note: note);
          case null:
            break;
        }
    }
  }

  Future<void> _openScanner() async {
    await context.push(AppRoutes.scan);
    if (mounted) {
      ref.read(passengersControllerProvider(widget.tripId).notifier).refresh();
    }
  }

  Set<Marker> _markersFor(LatLng position) => {
        Marker(
          markerId: const MarkerId('driver'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: context.l10n.tripMapYourLocation),
        ),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trip = widget.trip ?? ref.watch(activeTripForProvider(widget.tripId));
    final tracking = ref.watch(tripTrackingProvider);
    final passengers = ref.watch(passengersControllerProvider(widget.tripId));
    final profile = ref.watch(driverProfileProvider).valueOrNull;
    final ending = ref.watch(endTripControllerProvider);
    final pending = ref.watch(syncQueueProvider).pending;

    ref.listen<GeoPoint?>(
      tripTrackingProvider.select((s) => s.lastPosition),
      (_, next) {
        if (next != null) {
          _mapController?.animateCamera(
              CameraUpdate.newLatLng(LatLng(next.lat, next.lng)));
        }
      },
    );
    ref.listen(passengersControllerProvider(widget.tripId), (_, next) {
      if (next.hasError && !next.hasValue) {
        AppSnack.error(context,
            errorText(l10n, next.error!, fallback: l10n.tripPassengersLoadFailed));
      }
    });

    if (trip == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F3FF),
        body: Column(
          children: [
            TripHeader(
              title: l10n.tripDefaultName,
              connected: false,
              onBack: () => context.go(AppRoutes.home),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppEmptyView(
                        icon: Icons.directions_bus_outlined, title: ''),
                    Text(l10n.tripNotFound),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.tripBackHome),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final last = tracking.lastPosition;
    final driverPosition =
        last == null ? _fallbackCenter : LatLng(last.lat, last.lng);
    final pState = passengers.valueOrNull;
    final total = pState?.total ?? 0;
    final picked = pState?.pickedCount ?? 0;
    final driverName = (profile?.fullname.isNotEmpty ?? false)
        ? profile!.fullname
        : l10n.tripDriverFallback;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          TripHeader(
            title: trip.name ?? l10n.tripDefaultName,
            connected: tracking.socketConnected,
            onBack: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: Stack(
              children: [
                ref.watch(tripMapBuilderProvider)(
                  context,
                  target: driverPosition,
                  markers: _markersFor(driverPosition),
                  onCreated: (c) => _mapController = c,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      await context.push(AppRoutes.passengersOf(widget.tripId));
                      // Refresh counts after picks/drops on that screen.
                      if (mounted) {
                        ref
                            .read(passengersControllerProvider(widget.tripId)
                                .notifier)
                            .refresh();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
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
                            l10n.tripPassengersCount(total),
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
                const Positioned(top: 12, left: 16, child: SosButton()),
                Positioned(
                  top: 84,
                  left: 16,
                  right: 16,
                  child: ValueListenableBuilder<int>(
                    valueListenable: pending,
                    builder: (context, count, _) => TripBanners(
                      isTracking: tracking.isTracking,
                      pending: count,
                      onTurnOn: _startTracking,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: TripBottomCard(
                    driverName: driverName,
                    routeTitle: trip.routeTitle ?? '—',
                    shift: l10n.tripDefaultShift,
                    date: '—',
                    total: total,
                    picked: picked,
                    ending: ending,
                    onScan: _openScanner,
                    onEndTrip: _endTrip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
