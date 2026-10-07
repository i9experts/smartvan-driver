import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/checklist_item_def.dart';

/// One checklist question with OK / Issue chips (and a note field on Issue).
class ChecklistItemCard extends StatelessWidget {
  const ChecklistItemCard({
    super.key,
    required this.item,
    required this.answer,
    required this.noteController,
    required this.onAnswer,
  });

  final ChecklistItemDef item;

  /// true = OK, false = issue, null = not answered yet.
  final bool? answer;
  final TextEditingController? noteController;
  final void Function(bool ok) onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.label,
                      style: const TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
                ChoiceChip(
                  label: Text(l10n.checklistOk),
                  selected: answer == true,
                  selectedColor: const Color(0xFF27AE60).withValues(alpha: 0.2),
                  onSelected: (_) => onAnswer(true),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: Text(l10n.checklistIssue),
                  selected: answer == false,
                  selectedColor: const Color(0xFFE53935).withValues(alpha: 0.2),
                  onSelected: (_) => onAnswer(false),
                ),
              ],
            ),
            if (answer == false)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: noteController,
                  maxLength: 200,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.checklistNoteHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
