import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// "[name] not at stop?" — asks for an optional note. Returns the note
/// (possibly empty) when the driver moves on, null when they keep waiting.
Future<String?> showNoShowDialog(BuildContext context, String name) {
  return showDialog<String>(
    context: context,
    builder: (_) => _NoShowDialog(name: name),
  );
}

/// Owns the note field's controller, so it is disposed only once the dialog
/// has finished closing.
class _NoShowDialog extends StatefulWidget {
  const _NoShowDialog({required this.name});

  final String name;

  @override
  State<_NoShowDialog> createState() => _NoShowDialogState();
}

class _NoShowDialogState extends State<_NoShowDialog> {
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.passengersNoShowTitle(widget.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.passengersNoShowBody),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            maxLength: 200,
            decoration: InputDecoration(hintText: l10n.passengersNoShowHint),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.passengersKeepWaiting)),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, _note.text),
            child: Text(l10n.passengersMoveOn)),
      ],
    );
  }
}

/// Asks before picking up a kid whose parent said they are absent today.
Future<bool> confirmPickUpAbsent(BuildContext context, String? name) async {
  final l10n = context.l10n;
  final pick = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.passengersAbsentDialogTitle),
      content: Text(l10n.passengersAbsentDialogBody(
          (name == null || name.isEmpty) ? l10n.passengersThisStudent : name)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel)),
        ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.passengersPickUpConfirm)),
      ],
    ),
  );
  return pick == true;
}
