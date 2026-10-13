import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/formatting/date_formats.dart';
import '../../../../core/map/animated_van_marker.dart';
import '../../../../core/map/follow_camera.dart';
import '../../../../core/map/map_compass.dart';
import '../../../../core/map/map_compass_button.dart';
import '../../../../core/map/stop_marker_icon.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../passengers/application/passengers_controller.dart';
import '../../../profile/application/driver_profile_provider.dart';
import '../../../rating/application/rating_providers.dart';
import '../../../safety/presentation/widgets/sos_button.dart';
import '../../application/active_trip_provider.dart';
import '../../application/battery_guard.dart';
import '../../application/end_trip_controller.dart';
import '../../application/optimize_route_controller.dart';
import '../../application/stop_icons.dart';
import '../../application/trip_map_controller.dart';
import '../../application/trip_tracking.dart';
import '../../data/models/active_trip.dart';
import '../../data/models/geo_point.dart';
import '../../data/models/trip_type.dart';
import '../widgets/kids_not_dropped_sheet.dart';
import '../widgets/oem_guide_sheet.dart';
import '../widgets/optimized_route_sheet.dart';
import '../widgets/recenter_button.dart';
import '../widgets/trip_banners.dart';
import '../widgets/trip_bottom_card.dart';
import '../widgets/trip_header.dart';
import '../widgets/trip_map_button.dart';
import '../widgets/trip_map_layers.dart';
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

  /// Keeps the camera on the van until the driver moves the map.
  final FollowCameraController _follow = FollowCameraController();

  /// The compass button: north up / heading up, and the needle's bearing.
  late final MapCompassController _compass =
      MapCompassController(follow: _follow);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTracking());
  }

  @override
  void dispose() {
    // Tracking intentionally keeps running — it belongs to the trip, not to
    // this screen. It stops only when the trip is ended.
    _compass.dispose();
    _follow.dispose();
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
    if (result == TrackingStartResult.started) await _batterySetup();
  }

  /// First trip on this phone: ask to be exempt from battery optimization,
  /// and on phones that stop background apps explain the one setting to
  /// change. Remembered, so it is not asked again.
  Future<void> _batterySetup() async {
    final guard = ref.read(batteryGuardProvider);
    final guide = await guard.run();
    if (guide == null || !mounted) return;
    await OemGuideSheet.show(
        context, guide, () => guard.openSettingsFor(guide));
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
              backgroundColor: const Color(0xFF1B3B69),
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
        await _goAfterEnd();
      case UnsyncedUpdates(:final count):
        AppSnack.error(context, l10n.tripPendingSync(count));
      case EndTripFailed(:final error):
        AppSnack.error(
            context, errorText(l10n, error, fallback: l10n.tripEndFailed));
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

  /// Gives the driver a chance to rate the parent(s) on this trip before
  /// heading home. Best-effort — if the check fails, just go home.
  Future<void> _goAfterEnd() async {
    final tripId = widget.tripId;
    ref.invalidate(pendingRateesProvider(tripId));
    final pending = await ref.read(pendingRateesProvider(tripId).future);
    if (!mounted) return;
    context.go(pending.isEmpty ? AppRoutes.home : AppRoutes.rateTripOf(tripId));
  }

  /// Advisory only — never blocks the driver's own judgment. Asks the backend
  /// for the stops' best order from the van's position and shows it as a
  /// suggestion to take or leave.
  Future<void> _optimizeRoute() async {
    final l10n = context.l10n;
    final last = ref.read(tripTrackingProvider).lastPosition;
    final result =
        await ref.read(optimizeRouteControllerProvider.notifier).optimize(
              tripId: widget.tripId,
              position: last ??
                  GeoPoint(
                      lat: _fallbackCenter.latitude,
                      lng: _fallbackCenter.longitude),
            );
    if (!mounted) return;
    switch (result) {
      case RouteOptimized(:final route):
        await OptimizedRouteSheet.show(context, route);
      case OptimizeRouteFailed():
        AppSnack.error(context, l10n.tripOptimizeFailed);
      case null:
        break;
    }
  }

  Future<void> _openScanner() async {
    await context.push(AppRoutes.scan);
    if (mounted) {
      ref.read(passengersControllerProvider(widget.tripId).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trip = widget.trip ?? ref.watch(activeTripForProvider(widget.tripId));
    final tracking = ref.watch(tripTrackingProvider);
    final passengers = ref.watch(passengersControllerProvider(widget.tripId));
    final profile = ref.watch(driverProfileProvider).valueOrNull;
    final ending = ref.watch(endTripControllerProvider);
    final optimizing = ref.watch(optimizeRouteControllerProvider);
    final pending = ref.watch(syncQueueProvider).pending;
    final plan =
        ref.watch(routePlanControllerProvider(widget.tripId)).valueOrNull;
    final trail =
        ref.watch(tripTrailControllerProvider(widget.tripId)).valueOrNull ??
            const <LatLng>[];
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final stopIcons = <StopMarkerStyle, BitmapDescriptor>{
      if (plan != null)
        for (final style in stopStylesOf(plan))
          if (ref
                  .watch(stopIconProvider((style: style, ratio: ratio)))
                  .valueOrNull
              case final icon?)
            style: icon,
    };
    final planMarkerSet = plan == null
        ? const <Marker>{}
        : planMarkers(plan, icons: stopIcons, schoolTitle: l10n.tripMapSchool);
    final lines = mapLines(plan: plan, trail: trail);

    ref.listen(passengersControllerProvider(widget.tripId), (_, next) {
      if (next.hasError && !next.hasValue) {
        AppSnack.error(
            context,
            errorText(l10n, next.error!,
                fallback: l10n.tripPassengersLoadFailed));
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
                AnimatedVanMarker(
                  position: last == null ? null : LatLng(last.lat, last.lng),
                  speedMetersPerSecond: tracking.lastSpeed,
                  title: l10n.tripMapYourLocation,
                  onPose: (pose) => _follow.onPose(pose,
                      speedMetersPerSecond:
                          ref.read(tripTrackingProvider).lastSpeed),
                  builder: (context, markers) => Listener(
                    // Touching the map means the driver is looking around.
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (_) => _follow.userMoved(),
                    child: ref.watch(tripMapBuilderProvider)(
                      context,
                      target: driverPosition,
                      markers: {...planMarkerSet, ...markers},
                      polylines: lines,
                      onCameraMove: _compass.onCameraMove,
                      onCreated: (c) {
                        _mapController = c;
                        _follow.attachMap(c, zoom: () => _compass.zoom);
                        _compass.attachMap(c);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TripMapButton(
                        icon: Icons.people,
                        label: l10n.tripPassengersCount(total),
                        onTap: () async {
                          await context
                              .push(AppRoutes.passengersOf(widget.tripId));
                          // Refresh counts after picks/drops on that screen.
                          if (mounted) {
                            ref
                                .read(
                                    passengersControllerProvider(widget.tripId)
                                        .notifier)
                                .refresh();
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TripMapButton(
                        icon: Icons.alt_route,
                        label: l10n.tripOptimize,
                        busy: optimizing,
                        onTap: optimizing ? null : _optimizeRoute,
                      ),
                    ],
                  ),
                ),
                const Positioned(top: 12, left: 16, child: SosButton()),
                Positioned(
                  top: 116,
                  left: 16,
                  right: 16,
                  child: ValueListenableBuilder<int>(
                    valueListenable: pending,
                    builder: (context, count, _) => TripBanners(
                      isTracking: tracking.isTracking,
                      gpsWeak: tracking.gpsWeak,
                      needsAlwaysLocation: tracking.backgroundLocationLimited,
                      onOpenSettings: openAppSettings,
                      pending: count,
                      onTurnOn: _startTracking,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Always there, just above the bottom card: the compass,
                      // and Re-center once the driver moved the map away.
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              end: 16, bottom: 12),
                          child: ListenableBuilder(
                            listenable: Listenable.merge([_follow, _compass]),
                            builder: (context, _) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MapCompassButton(
                                  bearing: _compass.bearing,
                                  headingUp: _compass.headingUp,
                                  semanticLabel: switch (_compass.nextAction) {
                                    CompassTapAction.pointNorth =>
                                      l10n.tripCompassNorth,
                                    CompassTapAction.headingUp =>
                                      l10n.tripCompassHeadingUp,
                                  },
                                  onPressed: _compass.onPressed,
                                ),
                                if (!_follow.following) ...[
                                  const SizedBox(height: 8),
                                  RecenterButton(onPressed: _follow.recenter),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      TripBottomCard(
                        driverName: driverName,
                        routeTitle: trip.routeTitle ?? '—',
                        shift: switch (trip.type) {
                          TripType.pick => l10n.tripShiftMorning,
                          TripType.drop => l10n.tripShiftAfternoon,
                          TripType.unknown => '—',
                        },
                        date: trip.startTime == null
                            ? '—'
                            : formatDayMonthYear(trip.startTime!),
                        total: total,
                        picked: picked,
                        ending: ending,
                        onScan: _openScanner,
                        onEndTrip: _endTrip,
                      ),
                    ],
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
