import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/formatting/pkt.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/bottom_inset.dart';
import '../../../../l10n/l10n.dart';
import '../../application/history_rows.dart';
import '../../application/trip_history_providers.dart';
import '../../application/trip_history_state.dart';
import '../widgets/completed_trip_card.dart';
import '../widgets/history_filter_bar.dart';
import '../widgets/history_states.dart';

/// Every finished trip, newest first, grouped by day: infinite scroll,
/// pull-to-refresh and an All / Pick / Drop filter.
class TripHistoryScreen extends ConsumerWidget {
  const TripHistoryScreen({super.key});

  /// Start loading the next page this far (px) before the end.
  static const _prefetchExtent = 400.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final history = ref.watch(tripHistoryProvider);
    final controller = ref.read(tripHistoryProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.popOrGo(AppRoutes.home)),
        title: Text(l10n.historyTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: Column(
        children: [
          HistoryFilterBar(
            selected: history.valueOrNull?.filter,
            onSelected: controller.setFilter,
          ),
          Expanded(
            child: AsyncValueView<TripHistoryState>(
              value: history,
              loading: const HistorySkeleton(),
              errorFallback: l10n.historyLoadFailed,
              onRetry: () => ref.invalidate(tripHistoryProvider),
              data: (state) => _List(state: state),
            ),
          ),
        ],
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.state});

  final TripHistoryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(tripHistoryProvider.notifier);
    final rows = groupByDay(state.visible);
    final now = ref.watch(clockProvider)();

    void loadMoreNear(ScrollMetrics m) {
      if (m.extentAfter < TripHistoryScreen._prefetchExtent &&
          !state.loadMoreFailed) {
        controller.loadMore(untilVisible: state.visible.isEmpty);
      }
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: controller.refresh,
      child: NotificationListener<Notification>(
        onNotification: (n) {
          if (n is ScrollNotification) loadMoreNear(n.metrics);
          if (n is ScrollMetricsNotification) loadMoreNear(n.metrics);
          return false;
        },
        child: rows.isEmpty
            ? _Empty(state: state)
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: withBottomInset(
                    context, const EdgeInsets.fromLTRB(16, 8, 16, 16)),
                itemCount: rows.length + 1,
                itemBuilder: (context, i) {
                  if (i == rows.length) return _Footer(state: state);
                  return switch (rows[i]) {
                    HistoryHeaderRow(:final day) => Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(_dayLabel(context, day, now),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMuted)),
                      ),
                    HistoryTripRow(:final trip) => CompletedTripCard(
                        trip: trip,
                        onTap: () => context
                            .push(AppRoutes.tripHistoryDetailsOf(trip.id)),
                      ),
                  };
                },
              ),
      ),
    );
  }

  String _dayLabel(BuildContext context, DateTime day, DateTime now) {
    final l10n = context.l10n;
    final ago = pktDaysBetween(day, now);
    if (ago == 0) return l10n.historyToday;
    if (ago == 1) return l10n.historyYesterday;
    return formatPktDay(day, Localizations.localeOf(context).toString());
  }
}

/// Spinner while a page loads, a retry row when it failed.
class _Footer extends ConsumerWidget {
  const _Footer({required this.state});

  final TripHistoryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (state.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
            child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppTheme.primary))),
      );
    }
    if (state.loadMoreFailed) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(l10n.historyLoadMoreFailed,
                style:
                    const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            TextButton(
              onPressed: () => ref
                  .read(tripHistoryProvider.notifier)
                  .loadMore(untilVisible: state.visible.isEmpty),
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.state});

  final TripHistoryState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Scrollable so pull-to-refresh works on an empty list.
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: c.maxHeight,
          child: state.loadingMore
              ? const AppLoading()
              : AppEmptyView(
                  icon: Icons.history,
                  title: l10n.historyEmptyTitle,
                  message: state.filter == null
                      ? l10n.historyEmptyBody
                      : l10n.historyEmptyFilter,
                ),
        ),
      ),
    );
  }
}
