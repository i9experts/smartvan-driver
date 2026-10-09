import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/l10n.dart';
import '../../application/alerts_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/alerts_empty_state.dart';
import '../widgets/send_alert_sheet.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final alertsAsync = ref.watch(alertsProvider);

    final Widget body;
    if (alertsAsync.hasValue) {
      final alerts = alertsAsync.requireValue;
      body = alerts.isEmpty
          ? const AlertsEmptyState()
          : RefreshIndicator(
              onRefresh: () => ref.refresh(alertsProvider.future),
              color: const Color(0xFF1B3B69),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return AlertCard(
                    alert: alert,
                    onTap: () => context.push(
                      AppRoutes.alertDetailOf(alert.id ?? '$index'),
                      extra: alert,
                    ),
                  );
                },
              ),
            );
    } else if (alertsAsync.hasError) {
      body = LoadErrorView(
        title: l10n.alertsLoadErrorTitle,
        message: l10n.alertsLoadErrorBody,
        retryLabel: l10n.commonRetry,
        onRetry: () => ref.invalidate(alertsProvider),
      );
    } else {
      body = const AppLoading();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          GradientHeader(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.alertsTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                GestureDetector(
                  onTap: () => showSendAlertSheet(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEC610),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.send,
                            color: Color(0xFF1B3B69), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          l10n.alertsSend,
                          style: const TextStyle(
                            color: Color(0xFF1B3B69),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
