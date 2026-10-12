import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/l10n.dart';
import '../../application/maps_directions.dart';
import '../../data/models/optimized_route.dart';

/// The suggested stop order with what it saves, and a hand-off to Google Maps
/// for the actual navigation. Advisory only: dismissing it changes nothing.
class OptimizedRouteSheet extends ConsumerWidget {
  const OptimizedRouteSheet({super.key, required this.route});

  final OptimizedRoute route;

  static Future<void> show(BuildContext context, OptimizedRoute route) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => OptimizedRouteSheet(route: route),
      );

  Future<void> _openInGoogleMaps(BuildContext context, WidgetRef ref) async {
    final uri = googleMapsDirectionsUri(route);
    if (uri == null) return;
    final l10n = context.l10n;
    try {
      await ref.read(externalUrlLauncherProvider)(uri);
    } catch (_) {
      if (context.mounted) AppSnack.error(context, l10n.tripOpenMapsFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final hasSavings = route.hasSavings;
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEAECF0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.alt_route, color: Color(0xFF1B3B69)),
                  const SizedBox(width: 8),
                  Text(
                    l10n.tripOptimizeTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: hasSavings
                      ? const Color(0xFF27AE60).withValues(alpha: 0.08)
                      : const Color(0xFFF0F3FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  hasSavings
                      ? l10n.tripOptimizeSaves(
                          route.durationSavedMinutes.round(),
                          route.distanceSavedKm.toStringAsFixed(1))
                      : l10n.tripOptimizeAlreadyGood,
                  style: TextStyle(
                    fontSize: 13,
                    color: hasSavings
                        ? const Color(0xFF1C7A42)
                        : const Color(0xFF5B6B8C),
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                itemCount: route.stops.length,
                itemBuilder: (context, i) {
                  final stop = route.stops[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B3B69),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${stop.sequence ?? i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            stop.kidName ?? l10n.tripOptimizeStudent,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1A1A2E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openInGoogleMaps(context, ref),
                      icon: const Icon(Icons.map_outlined,
                          color: Colors.white, size: 18),
                      label: Text(l10n.tripOptimizeOpenMaps,
                          style: const TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3B69),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.tripOptimizeOwnOrder,
                      style: const TextStyle(
                          color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
