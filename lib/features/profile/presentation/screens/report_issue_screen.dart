import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/providers/image_picker_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/report_issue_controller.dart';
import '../../data/models/issue_type.dart';
import '../widgets/issue_type_label.dart';
import '../widgets/issue_type_sheet.dart';
import '../widgets/report_success_overlay.dart';

class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _descriptionController = TextEditingController();
  IssueType _selectedIssueType = IssueType.vehicleIssue;
  File? _selectedImage;
  bool _showSuccess = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ref
          .read(imagePickerProvider)
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (picked != null && mounted) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (_) {
      // e.g. gallery permission denied on some devices — surface it instead
      // of an unhandled exception with no feedback.
      if (mounted) AppSnack.error(context, context.l10n.reportGalleryFailed);
    }
  }

  Future<void> _pickIssueType() async {
    final type =
        await showIssueTypeSheet(context, selected: _selectedIssueType);
    if (type != null && mounted) setState(() => _selectedIssueType = type);
  }

  Future<void> _submit() async {
    if (_descriptionController.text.isEmpty) {
      AppSnack.error(context, context.l10n.reportDescribeIssue);
      return;
    }
    final ok = await ref.read(reportIssueControllerProvider.notifier).submit(
          issueType: _selectedIssueType,
          description: _descriptionController.text,
          photo: _selectedImage,
        );
    if (ok && mounted) setState(() => _showSuccess = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final saving = ref.watch(reportIssueControllerProvider).isLoading;

    ref.listen(reportIssueControllerProvider, (_, next) {
      final error = next.error;
      if (error == null) return;
      // Never claim success on a failure: show why it failed.
      AppSnack.error(
        context,
        error is ApiError && error.code == 'UPLOAD_FAILED'
            ? errorText(l10n, error)
            : errorText(l10n, error, fallback: l10n.reportSubmitFailed),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Stack(
        children: [
          Column(
            children: [
              ScreenHeader(
                title: l10n.reportTitle,
                onBack: () => context.popOrGo(AppRoutes.profile),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel(l10n.reportSelectIssueType),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickIssueType,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEAECF0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedIssueType.label(l10n),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A1A2E),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xFF8A94A6)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FieldLabel(l10n.reportDescription),
                      const SizedBox(height: 8),
                      _DescriptionField(
                        controller: _descriptionController,
                        hint: l10n.reportDescriptionHint,
                      ),
                      const SizedBox(height: 16),
                      FieldLabel(l10n.reportUploadPhoto),
                      const SizedBox(height: 4),
                      Text(
                        l10n.reportUploadPhotoHint,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PhotoBox(image: _selectedImage, onTap: _pickImage),
                      const SizedBox(height: 32),
                      PrimaryActionButton(
                        label: l10n.reportSubmit,
                        trailingIcon: Icons.arrow_forward,
                        loading: saving,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showSuccess)
            ReportSuccessOverlay(
                onDone: () => context.popOrGo(AppRoutes.profile)),
        ],
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF8A94A6),
          fontSize: 13,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: Colors.white,
        border: border(const Color(0xFFEAECF0)),
        enabledBorder: border(const Color(0xFFEAECF0)),
        focusedBorder: border(const Color(0xFF1B3B69), 2),
      ),
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox({required this.image, required this.onTap});

  final File? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3B69).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined,
                        color: Color(0xFF1B3B69), size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.reportUpload,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1B3B69),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
