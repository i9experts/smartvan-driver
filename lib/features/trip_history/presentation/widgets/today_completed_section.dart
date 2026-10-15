import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../application/trip_history_providers.dart';
import 'completed_trip_card.dart';

/// Home: today's (PKT) completed trips, at most three, with "View all".
class TodayCompletedSection extends ConsumerWidget {
  const TodayCompletedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final trips = ref.watch(todayCompletedTripsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.homeTodayCompletedTitle,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.tripHistory),
              child: Text(l10n.homeViewAll),
            ),
          ],
        ),
        const SizedBox(height: 8),
        trips.when(
          skipLoadingOnRefresh: true,
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
                child: CircularProgressIndicator(color: AppTheme.primary)),
          ),
          error: (_, __) => _Note(
            text: l10n.historyLoadFailed,
            action: TextButton(
              onPressed: () => ref.invalidate(todayCompletedTripsProvider),
              child: Text(l10n.commonRetry),
            ),
          ),
          data: (items) => items.isEmpty
              ? _Note(text: l10n.homeNoTripsCompletedToday)
              : Column(
                  children: [
                    for (final trip in items)
                      CompletedTripCard(
                        trip: trip,
                        onTap: () => context
                            .push(AppRoutes.tripHistoryDetailsOf(trip.id)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            if (action != null) action!,
          ],
        ),
      );
}
