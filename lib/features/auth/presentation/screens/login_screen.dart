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
import '../widgets/login_header.dart';

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
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const LoginHeader(),
              // Leaves room for the van in the backdrop photo.
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          l10n.loginWelcome,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.loginSubtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A94A6),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 28),
                        LoginFieldLabel(l10n.loginIdLabel),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _loginIdController,
                          keyboardType: TextInputType.text,
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
                          decoration: loginInputDecoration(
                            hint: l10n.loginPasswordHint,
                            icon: Icons.lock_outlined,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF8A94A6),
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
