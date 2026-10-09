import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/image_picker_provider.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/checklist_providers.dart';
import '../../application/submit_checklist_controller.dart';
import '../../data/models/checklist_answer.dart';
import '../widgets/checklist_item_card.dart';
import '../widgets/checklist_photo_card.dart';

/// Daily vehicle check. Pops `true` after a successful submit.
class ChecklistScreen extends ConsumerStatefulWidget {
  const ChecklistScreen({super.key, this.routeId});

  final String? routeId;

  @override
  ConsumerState<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends ConsumerState<ChecklistScreen> {
  static const _navy = Color(0xFF1B3B69);

  // Form state: what the driver has tapped / typed so far.
  final Map<String, bool> _answers = {};
  final Map<String, TextEditingController> _notes = {};
  File? _photo;
  String? _existingPhotoUrl;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<ChecklistFormData>>(
      checklistFormDataProvider,
      (_, next) => _seed(next.valueOrNull),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    for (final c in _notes.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Pre-fills from today's saved check, once (re-submitting updates it).
  void _seed(ChecklistFormData? data) {
    if (_seeded || data == null) return;
    _seeded = true;
    for (final i in data.items) {
      _notes.putIfAbsent(i.key, TextEditingController.new);
    }
    final saved = data.today.checklist;
    if (saved != null) {
      for (final a in saved.items) {
        if (a.key.isEmpty) continue;
        _answers[a.key] = a.ok;
        if (a.note != null) _notes[a.key]?.text = a.note!;
      }
      _existingPhotoUrl = saved.photoUrl;
    }
  }

  Future<void> _takePhoto() async {
    final picked = await ref.read(imagePickerProvider).pickImage(
        source: ImageSource.camera, imageQuality: 70, maxWidth: 1600);
    if (picked != null && mounted) setState(() => _photo = File(picked.path));
  }

  Future<bool> _askSubmitWithoutPhoto() async {
    final l10n = context.l10n;
    final go = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.checklistPhotoFailedTitle),
        content: Text(l10n.checklistPhotoFailedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.checklistSubmitWithoutPhoto),
          ),
        ],
      ),
    );
    return go == true;
  }

  Future<void> _submit(ChecklistFormData data) async {
    final l10n = context.l10n;
    final answers = [
      for (final i in data.items)
        ChecklistAnswer(
          key: i.key,
          ok: _answers[i.key]!,
          note: !_answers[i.key]! &&
                  (_notes[i.key]?.text.trim().isNotEmpty ?? false)
              ? _notes[i.key]!.text.trim()
              : null,
        ),
    ];
    final issues = answers.where((a) => !a.ok).length;
    final controller = ref.read(submitChecklistControllerProvider.notifier);
    var result = await controller.submit(
      routeId: widget.routeId,
      answers: answers,
      photo: _photo,
      existingPhotoUrl: _existingPhotoUrl,
    );
    if (!mounted) return;
    if (result == ChecklistSubmitResult.photoUploadFailed) {
      if (!await _askSubmitWithoutPhoto() || !mounted) return;
      result = await controller.submit(
        routeId: widget.routeId,
        answers: answers,
        photo: _photo,
        existingPhotoUrl: _existingPhotoUrl,
        withoutPhoto: true,
      );
    }
    final ok = result == ChecklistSubmitResult.saved;
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            issues > 0 ? l10n.checklistSavedIssues : l10n.checklistSavedOk),
        backgroundColor:
            issues > 0 ? const Color(0xFFFEC610) : const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
      ));
      context.pop(true);
    } else {
      final error = ref.read(submitChecklistControllerProvider).error!;
      AppSnack.error(
          context, errorText(l10n, error, fallback: l10n.checklistSaveFailed));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(checklistFormDataProvider);
    final saving = ref.watch(submitChecklistControllerProvider).isLoading;
    final data = dataAsync.valueOrNull;

    final Widget body;
    if (data != null) {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(l10n.checklistIntro,
              style: const TextStyle(
                  color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
          const SizedBox(height: 12),
          for (final item in data.items)
            ChecklistItemCard(
              item: item,
              answer: _answers[item.key],
              noteController: _notes[item.key],
              onAnswer: (ok) => setState(() => _answers[item.key] = ok),
            ),
          const SizedBox(height: 8),
          ChecklistPhotoCard(
            photo: _photo,
            hasExistingPhoto: _existingPhotoUrl?.isNotEmpty ?? false,
            onTake: _takePhoto,
          ),
        ],
      );
    } else if (dataAsync.hasError) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorText(l10n, dataAsync.error!,
                    fallback: l10n.checklistLoadFailed),
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(checklistFormDataProvider),
                child: Text(l10n.checklistTryAgain),
              ),
            ],
          ),
        ),
      );
    } else {
      body = const AppLoading();
    }

    final complete = data != null &&
        data.items.isNotEmpty &&
        data.items.every((i) => _answers.containsKey(i.key));
    final issues = _answers.values.where((ok) => !ok).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(l10n.checklistTitle,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 18)),
      ),
      body: body,
      bottomNavigationBar: data == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: complete && !saving ? () => _submit(data) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          issues > 0 ? const Color(0xFFFEC610) : _navy,
                      foregroundColor: issues > 0 ? _navy : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(
                            !complete
                                ? l10n.checklistAnswerAll(
                                    _answers.length, data.items.length)
                                : issues > 0
                                    ? l10n.checklistSubmitIssues(issues)
                                    : l10n.checklistSubmitOk,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
    );
  }
}
