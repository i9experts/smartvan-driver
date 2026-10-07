import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/alert.dart';
import 'alert_style.dart';

/// "5m ago", "3h ago", "2d ago".
String relativeAlertTime(AppLocalizations l10n, DateTime time, DateTime now) {
  final diff = now.difference(time.toLocal());
  if (diff.inMinutes < 60) return l10n.alertsMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.alertsHoursAgo(diff.inHours);
  return l10n.alertsDaysAgo(diff.inDays);
}

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert, required this.onTap});

  final Alert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = AlertStyle.forList(alert.type);
    final title = alert.title ?? alert.message ?? l10n.alertsDefaultTitle;
    final body = alert.title != null ? (alert.message ?? '') : '';
    final time = alert.createdAt;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(style.icon, color: style.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (time != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        relativeAlertTime(l10n, time, DateTime.now()),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Color(0xFF8A94A6)),
            ],
          ),
        ),
      ),
    );
  }
}
