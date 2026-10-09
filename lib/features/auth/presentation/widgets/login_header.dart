import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// Logo and product name at the top of the login screen.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact = MediaQuery.sizeOf(context).height < 700;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: compact ? 16 : 32),
      child: Column(
        children: [
          Container(
            width: compact ? 72 : 100,
            height: compact ? 72 : 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(compact ? 12 : 16),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: compact ? 8 : 16),
          Text(
            l10n.appTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              shadows: [Shadow(color: Color(0x99000000), blurRadius: 10)],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.loginPortal,
            style: const TextStyle(
              color: Color(0xFFFEC610),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Color(0xCC000000), blurRadius: 10)],
            ),
          ),
        ],
      ),
    );
  }
}
