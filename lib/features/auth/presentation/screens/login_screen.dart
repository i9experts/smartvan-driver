import 'package:flutter/material.dart';
import '../../../../core/widgets/auth_backdrop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/login_controller.dart';
import '../widgets/login_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_loginIdController.text.isEmpty || _passwordController.text.isEmpty) {
      AppSnack.error(context, context.l10n.loginFillAll);
      return;
    }
    final ok = await ref.read(loginControllerProvider.notifier).signIn(
          loginId: _loginIdController.text,
          password: _passwordController.text,
        );
    if (ok && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final login = ref.watch(loginControllerProvider);
    // Hide the header while the keyboard is up so the form and Sign In stay visible.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    // Shows the server's real reason (account not found, wrong password, ...)
    // and a proper "no internet" message when offline.
    ref.listen(loginControllerProvider, (_, next) {
      final error = next.error;
      if (error == null) return;
      AppSnack.error(
        context,
        error is AppException
            ? errorText(l10n, error, fallback: l10n.commonLoginFailed)
            : errorText(l10n, error),
      );
    });

    return Scaffold(
      body: AuthBackdrop(
        child: AuthSheet(
          children: [
            // One fixed slot (not a conditional spread) so the fields below keep
            // their element/focus when the keyboard opens and this collapses.
            keyboardOpen
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginWelcome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFEC610),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.loginSubtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
            LoginFieldLabel(l10n.loginIdLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _loginIdController,
              keyboardType: TextInputType.text,
              style: loginInputTextStyle,
              cursorColor: const Color(0xFFFEC610),
              decoration: loginInputDecoration(
                hint: l10n.loginIdHint,
                icon: Icons.phone_outlined,
              ),
            ),
            const SizedBox(height: 16),
            LoginFieldLabel(l10n.loginPasswordLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: loginInputTextStyle,
              cursorColor: const Color(0xFFFEC610),
              decoration: loginInputDecoration(
                hint: l10n.loginPasswordHint,
                icon: Icons.lock_outlined,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: login.isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEC610),
                  foregroundColor: const Color(0xFF1B3B69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: login.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1B3B69),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.loginSignIn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
