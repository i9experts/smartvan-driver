import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/bottom_inset.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/data/models/trip_trail.dart';
import '../../application/trip_history_providers.dart';
import '../../data/models/trip_details.dart';
import '../widgets/history_route_map.dart';
import '../widgets/trip_details_sections.dart';

/// One finished trip: its saved route on a static map, then the summary,
/// students and alerts.
class TripDetailsScreen extends ConsumerWidget {
  const TripDetailsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final details = ref.watch(tripDetailsProvider(tripId));
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        leading:
            BackButton(onPressed: () => context.popOrGo(AppRoutes.tripHistory)),
        title: Text(l10n.tripDetailsTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: AsyncValueView<TripDetails>(
        value: details,
        errorFallback: l10n.tripDetailsLoadFailed,
        onRetry: () => ref.invalidate(tripDetailsProvider(tripId)),
        data: (d) => _Content(tripId: tripId, details: d),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.tripId, required this.details});

  final String tripId;
  final TripDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // While the trail loads the map shows the stops and school; it is
    // refitted when the path arrives.
    final trail = ref.watch(historyTrailProvider(tripId)).valueOrNull ??
        const TripTrail();
    final height = math.min(320.0, MediaQuery.sizeOf(context).height * 0.38);
    return Column(
      children: [
        SizedBox(
          height: height,
          child: HistoryRouteMap(details: details, trail: trail),
        ),
        Expanded(
          child: ListView(
            padding: withBottomInset(context, const EdgeInsets.all(16)),
            children: [
              TripSummaryCard(trip: details.trip),
              TripStudentsCard(stops: details.stops),
              TripAlertsCard(alerts: details.alerts),
            ],
          ),
        ),
      ],
    );
  }
}
