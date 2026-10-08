import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/kid_not_dropped.dart';

/// What the driver chose when ending a drop trip with kids still on board.
sealed class KidsNotDroppedChoice {
  const KidsNotDroppedChoice();
}

class OpenPassengersChoice extends KidsNotDroppedChoice {
  const OpenPassengersChoice();
}

class ForceEndChoice extends KidsNotDroppedChoice {
  const ForceEndChoice(this.note);
  final String note;
}

/// Shown when the backend refuses to end a drop trip (409 KIDS_NOT_DROPPED).
/// The safe action (go and drop them) is primary; ending anyway needs the
/// driver to confirm they checked the van and write why.
class KidsNotDroppedSheet extends StatefulWidget {
  const KidsNotDroppedSheet({super.key, required this.kids});

  final List<KidNotDropped> kids;

  static Future<KidsNotDroppedChoice?> show(
      BuildContext context, List<KidNotDropped> kids) {
    return showModalBottomSheet<KidsNotDroppedChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => KidsNotDroppedSheet(kids: kids),
    );
  }

  @override
  State<KidsNotDroppedSheet> createState() => _KidsNotDroppedSheetState();
}

class _KidsNotDroppedSheetState extends State<KidsNotDroppedSheet> {
  static const _red = Color(0xFFE53935);
  static const _navy = Color(0xFF1B2B6B);
  static const _minNote = 5;

  bool _confirming = false;
  bool _checkedVan = false;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _canForce => _checkedVan && _note.text.trim().length >= _minNote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.airport_shuttle, color: _red, size: 44),
              const SizedBox(height: 8),
              Text(
                l10n.kidsNotDroppedTitle(widget.kids.length),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.kidsNotDroppedCheckSeats,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              for (final k in widget.kids)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.child_care, color: _red),
                  title: Text(
                      k.fullname.isEmpty
                          ? l10n.kidsNotDroppedStudent
                          : k.fullname,
                      style: const TextStyle(fontFamily: 'Poppins')),
                ),
              const SizedBox(height: 12),
              if (!_confirming) ...[
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pop(context, const OpenPassengersChoice()),
                  icon: const Icon(Icons.people),
                  label: Text(l10n.kidsNotDroppedGoToPassengers),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _confirming = true),
                  style: TextButton.styleFrom(foregroundColor: _red),
                  child: Text(l10n.kidsNotDroppedNotInVan),
                ),
              ] else ...[
                CheckboxListTile(
                  value: _checkedVan,
                  onChanged: (v) => setState(() => _checkedVan = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.kidsNotDroppedChecked,
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
                TextField(
                  controller: _note,
                  onChanged: (_) => setState(() {}),
                  maxLines: 2,
                  maxLength: 300,
                  decoration: InputDecoration(
                    labelText: l10n.kidsNotDroppedWhatHappened,
                    hintText: l10n.kidsNotDroppedExample,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Text(
                  l10n.kidsNotDroppedAlertInfo,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A94A6),
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _canForce
                      ? () => Navigator.pop(
                          context, ForceEndChoice(_note.text.trim()))
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.kidsNotDroppedEndAlert),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
