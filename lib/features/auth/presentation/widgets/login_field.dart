import 'package:flutter/material.dart';

/// Label above an input, as used on the login form.
class LoginFieldLabel extends StatelessWidget {
  const LoginFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
        fontFamily: 'Poppins',
      ),
    );
  }
}

/// The rounded white input style of the login form.
InputDecoration loginInputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xFF8A94A6),
      fontSize: 14,
      fontFamily: 'Poppins',
    ),
    prefixIcon: Icon(icon, color: const Color(0xFF1B2B6B)),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    border: border(const Color(0xFFEAECF0)),
    enabledBorder: border(const Color(0xFFEAECF0)),
    focusedBorder: border(const Color(0xFF1B2B6B), 2),
  );
}
