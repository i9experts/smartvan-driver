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
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    );
  }
}

/// Text style for typing into [loginInputDecoration] fields.
const loginInputTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
  fontFamily: 'Poppins',
);

/// The outlined, transparent input style of the login form (sits on the photo).
InputDecoration loginInputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  OutlineInputBorder border(Color color, [double width = 1.2]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Colors.white54,
      fontSize: 14,
      fontFamily: 'Poppins',
    ),
    prefixIcon: Icon(icon, color: Colors.white70, size: 20),
    suffixIcon: suffix,
    filled: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: border(Colors.white38),
    enabledBorder: border(Colors.white38),
    focusedBorder: border(const Color(0xFFFEC610), 1.6),
  );
}
