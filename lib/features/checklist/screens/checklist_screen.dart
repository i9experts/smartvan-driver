import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_errors.dart';
import '../../../core/network/api_service.dart';
import '../checklist_api.dart';

/// Daily vehicle check. Pops `true` after a successful submit.
class ChecklistScreen extends StatefulWidget {
  final String? routeId;
  const ChecklistScreen({super.key, this.routeId});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  static const _navy = Color(0xFF1B2B6B);
  static const _green = Color(0xFF27AE60);
  static const _red = Color(0xFFE53935);

  List<ChecklistItemDef> _items = [];
  final Map<String, bool> _answers = {};
  final Map<String, TextEditingController> _notes = {};
  File? _photo;
  String? _existingPhotoUrl;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _notes.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([ChecklistApi.items(), ChecklistApi.today()]);
      final items = results[0] as List<ChecklistItemDef>;
      final today = results[1] as TodayChecklist;
      for (final i in items) {
        _notes.putIfAbsent(i.key, () => TextEditingController());
      }
      // Pre-fill if already submitted today (re-submitting updates it).
      final saved = today.checklist?['items'];
      if (saved is List) {
        for (final s in saved.whereType<Map>()) {
          final key = s['key']?.toString();
          if (key == null) continue;
          if (s['ok'] is bool) _answers[key] = s['ok'] as bool;
          if (s['note'] != null) _notes[key]?.text = s['note'].toString();
        }
      }
      _existingPhotoUrl = today.checklist?['photoUrl']?.toString();
      setState(() => _items = items);
    } catch (e) {
      setState(() => _error = ApiErrors.message(e, fallback: 'Could not load the checklist.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _complete => _items.isNotEmpty && _items.every((i) => _answers.containsKey(i.key));
  int get _issues => _answers.values.where((ok) => !ok).length;

  Future<void> _takePhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1600);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_complete || _saving) return;
    setState(() => _saving = true);
    try {
      String? photoUrl = _existingPhotoUrl;
      if (_photo != null) photoUrl = await ApiService.uploadImage(_photo!);
      await ChecklistApi.submit(
        routeId: widget.routeId,
        photoUrl: photoUrl,
        items: _items.map((i) {
          final ok = _answers[i.key]!;
          final note = _notes[i.key]?.text.trim() ?? '';
          return {
            'key': i.key,
            'ok': ok,
            if (!ok && note.isNotEmpty) 'note': note,
          };
        }).toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_issues > 0
            ? 'Checklist saved. The school has been told about the issues.'
            : 'Checklist saved. Safe driving!'),
        backgroundColor: _issues > 0 ? const Color(0xFFFFB800) : _green,
        behavior: SnackBarBehavior.floating,
      ));
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ApiErrors.message(e, fallback: 'Could not save the checklist.')),
        backgroundColor: _red,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Daily van check',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : _error != null
              ? _errorView()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    const Text(
                      'Check each item before your first trip today.',
                      style: TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 12),
                    ..._items.map(_itemCard),
                    const SizedBox(height: 8),
                    _photoCard(),
                  ],
                ),
      bottomNavigationBar: _loading || _error != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _complete && !_saving ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _issues > 0 ? const Color(0xFFFFB800) : _navy,
                      foregroundColor: _issues > 0 ? _navy : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(
                            !_complete
                                ? 'Answer all items (${_answers.length}/${_items.length})'
                                : _issues > 0
                                    ? 'Submit and report $_issues issue${_issues == 1 ? '' : 's'}'
                                    : 'Submit — all OK',
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _itemCard(ChecklistItemDef item) {
    final answer = _answers[item.key];
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
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
                ChoiceChip(
                  label: const Text('OK'),
                  selected: answer == true,
                  selectedColor: _green.withOpacity(0.2),
                  onSelected: (_) => setState(() => _answers[item.key] = true),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Issue'),
                  selected: answer == false,
                  selectedColor: _red.withOpacity(0.2),
                  onSelected: (_) => setState(() => _answers[item.key] = false),
                ),
              ],
            ),
            if (answer == false)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: _notes[item.key],
                  maxLength: 200,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'What is the problem? (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoCard() {
    final hasPhoto = _photo != null || (_existingPhotoUrl?.isNotEmpty ?? false);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: _photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_photo!, width: 48, height: 48, fit: BoxFit.cover))
            : const Icon(Icons.photo_camera_outlined, color: _navy),
        title: Text(hasPhoto ? 'Photo added' : 'Add a photo (optional)',
            style: const TextStyle(fontFamily: 'Poppins')),
        subtitle: const Text('Helpful when reporting an issue',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
        trailing: TextButton(
          onPressed: _takePhoto,
          child: Text(hasPhoto ? 'Retake' : 'Take'),
        ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
