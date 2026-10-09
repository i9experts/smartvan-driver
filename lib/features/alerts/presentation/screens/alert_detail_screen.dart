import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/formatting/date_formats.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/l10n.dart';
import '../../application/alerts_provider.dart';
import '../../data/models/alert.dart';
import '../widgets/alert_style.dart';

/// One alert. [alertId] comes from the route; [alert] is an optional,
/// already-loaded copy used to show it without waiting for the list.
class AlertDetailScreen extends ConsumerWidget {
  const AlertDetailScreen({super.key, required this.alertId, this.alert});

  final String alertId;
  final Alert? alert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final Widget body;
    if (alert != null) {
      body = _AlertDetailBody(alert: alert!);
    } else {
      final alertsAsync = ref.watch(alertsProvider);
      body = AsyncValueView<List<Alert>>(
        value: alertsAsync,
        onRetry: () => ref.invalidate(alertsProvider),
        data: (alerts) {
          final match = alerts.where((a) => a.id == alertId).firstOrNull;
          return match == null
              ? AppEmptyView(
                  icon: Icons.notifications_off_outlined,
                  title: l10n.alertNotFound)
              : _AlertDetailBody(alert: match);
        },
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          ScreenHeader(
            title: l10n.alertDetailTitle,
            onBack: () => context.pop(),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _AlertDetailBody extends StatelessWidget {
  const _AlertDetailBody({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final style = AlertStyle.forDetail(alert.type);
    // The message is already shown in full below, so a type-specific heading
    // is used when the backend sends no title.
    final title = alert.title ?? alert.type.defaultTitle(l10n);
    final body = alert.message ?? '';
    final time = alert.date ?? alert.createdAt;
    final tripId = alert.tripId ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Card(
            radius: 20,
            padding: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: style.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(style.icon, color: style.color, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (time != null)
                            Text(
                              formatDateTimeLong(time, locale),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A94A6),
                                fontFamily: 'Poppins',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEAECF0)),
                  const SizedBox(height: 16),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A94A6),
                      fontFamily: 'Poppins',
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (tripId.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              l10n.alertDetailTripDetails,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              radius: 16,
              padding: 16,
              child: Column(
                children: [
                  _DetailRow(
                    label: l10n.alertDetailDate,
                    value: alert.date == null
                        ? '—'
                        : formatDateTimeLong(alert.date!, locale),
                  ),
                  const Divider(color: Color(0xFFEAECF0)),
                  _DetailRow(
                      label: l10n.alertDetailShift, value: alert.shift ?? '—'),
                  const Divider(color: Color(0xFFEAECF0)),
                  _DetailRow(
                    label: l10n.alertDetailStartTime,
                    value: alert.startTime == null
                        ? '—'
                        : formatDateTimeLong(alert.startTime!, locale),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEC610),
                  foregroundColor: const Color(0xFF1B3B69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alertDetailViewTrip,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(
      {required this.child, required this.radius, required this.padding});

  final Widget child;
  final double radius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
