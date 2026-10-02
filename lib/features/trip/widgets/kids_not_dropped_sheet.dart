import 'package:flutter/material.dart';

/// What the driver chose when ending a drop trip with kids still on board.
sealed class KidsNotDroppedChoice {
  const KidsNotDroppedChoice();
}

class OpenPassengersChoice extends KidsNotDroppedChoice {
  const OpenPassengersChoice();
}

class ForceEndChoice extends KidsNotDroppedChoice {
  final String note;
  const ForceEndChoice(this.note);
}

/// Shown when the backend refuses to end a drop trip (409 KIDS_NOT_DROPPED).
/// The safe action (go and drop them) is primary; ending anyway needs the
/// driver to confirm they checked the van and write why.
class KidsNotDroppedSheet extends StatefulWidget {
  final List<Map<String, dynamic>> kids;
  const KidsNotDroppedSheet({super.key, required this.kids});

  static Future<KidsNotDroppedChoice?> show(
      BuildContext context, List<Map<String, dynamic>> kids) {
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
    final n = widget.kids.length;
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
                n == 1 ? '1 student is still marked in the van' : '$n students are still marked in the van',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              const Text(
                'Please check every seat before ending the trip.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              ...widget.kids.map((k) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.child_care, color: _red),
                    title: Text(k['fullname']?.toString() ?? 'Student',
                        style: const TextStyle(fontFamily: 'Poppins')),
                  )),
              const SizedBox(height: 12),
              if (!_confirming) ...[
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pop(context, const OpenPassengersChoice()),
                  icon: const Icon(Icons.people),
                  label: const Text('Go to passengers and drop them'),
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
                  child: const Text('They are not in the van — end trip anyway'),
                ),
              ] else ...[
                CheckboxListTile(
                  value: _checkedVan,
                  onChanged: (v) => setState(() => _checkedVan = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I have checked the whole van and no child is inside.',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
                TextField(
                  controller: _note,
                  onChanged: (_) => setState(() {}),
                  maxLines: 2,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'What happened? (required)',
                    hintText: 'e.g. Parent picked him up from school',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Text(
                  'The school will be alerted, and these parents will be told the drop was not confirmed.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _canForce
                      ? () => Navigator.pop(context, ForceEndChoice(_note.text.trim()))
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('End trip and alert school'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
