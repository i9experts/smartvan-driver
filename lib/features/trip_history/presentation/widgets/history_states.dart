import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Grey placeholder cards while the first page loads.
class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        key: const Key('history-skeleton'),
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          for (var i = 0; i < 6; i++)
            Container(
              height: 96,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.border.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
        ],
      );
}
