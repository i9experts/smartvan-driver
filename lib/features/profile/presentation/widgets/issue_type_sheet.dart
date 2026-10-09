import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/issue_type.dart';
import 'issue_type_label.dart';

/// Bottom sheet that lets the driver pick an [IssueType].
Future<IssueType?> showIssueTypeSheet(
  BuildContext context, {
  required IssueType selected,
}) {
  return showModalBottomSheet<IssueType>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _IssueTypeSheet(selected: selected),
  );
}

class _IssueTypeSheet extends StatelessWidget {
  const _IssueTypeSheet({required this.selected});

  final IssueType selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFEAECF0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.reportSelectIssueType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Color(0xFF8A94A6)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final type in selectableIssueTypes)
            GestureDetector(
              onTap: () => Navigator.pop(context, type),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: selected == type
                      ? const Color(0xFF1B3B69).withValues(alpha: 0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected == type
                        ? const Color(0xFF1B3B69).withValues(alpha: 0.3)
                        : const Color(0xFFEAECF0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.label(l10n),
                      style: TextStyle(
                        fontSize: 14,
                        color: selected == type
                            ? const Color(0xFF1B3B69)
                            : const Color(0xFF1A1A2E),
                        fontWeight: selected == type
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (selected == type)
                      const Icon(Icons.check_circle,
                          color: Color(0xFF1B3B69), size: 20),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
