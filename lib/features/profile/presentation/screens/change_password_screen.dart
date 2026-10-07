import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/change_password_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_currentController.text.isEmpty ||
        _newController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      AppSnack.error(context, l10n.changePasswordFillAll);
      return;
    }
    if (_newController.text != _confirmController.text) {
      AppSnack.error(context, l10n.changePasswordMismatch);
      return;
    }
    if (_newController.text.length < 6) {
      AppSnack.error(context, l10n.changePasswordTooShort);
      return;
    }
    final ok = await ref.read(changePasswordControllerProvider.notifier).change(
          oldPassword: _currentController.text,
          newPassword: _newController.text,
        );
    if (ok && mounted) _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: Color(0xFF27AE60), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.changePasswordDoneTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.changePasswordHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8A94A6),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.go(AppRoutes.profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: const Color(0xFF1B2B6B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.commonDone,
                    style: const TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final saving = ref.watch(changePasswordControllerProvider).isLoading;

    ref.listen(changePasswordControllerProvider, (_, next) {
      final error = next.error;
      if (error != null) {
        AppSnack.error(context,
            errorText(l10n, error, fallback: l10n.changePasswordFailed));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          ScreenHeader(
            title: l10n.changePasswordTitle,
            onBack: () => context.go(AppRoutes.profile),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2B6B).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFF1B2B6B), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.changePasswordHint,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1B2B6B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  LabeledField(
                    label: l10n.changePasswordCurrent,
                    controller: _currentController,
                    icon: Icons.lock_outlined,
                    obscureText: _obscureCurrent,
                    onToggleObscure: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  const SizedBox(height: 16),
                  LabeledField(
                    label: l10n.changePasswordNew,
                    controller: _newController,
                    icon: Icons.lock_outlined,
                    obscureText: _obscureNew,
                    onToggleObscure: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  LabeledField(
                    label: l10n.changePasswordConfirm,
                    controller: _confirmController,
                    icon: Icons.lock_outlined,
                    obscureText: _obscureConfirm,
                    onToggleObscure: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 32),
                  PrimaryActionButton(
                    label: l10n.changePasswordUpdate,
                    trailingIcon: Icons.arrow_forward,
                    loading: saving,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
