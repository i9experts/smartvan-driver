import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The one way to show a snackbar. Replaces the hand-built red/green
/// `SnackBar`s that were copied into ~10 screens.
class AppSnack {
  AppSnack._();

  static void success(BuildContext context, String message) =>
      _show(context, message, AppTheme.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, AppTheme.error);

  static void warning(BuildContext context, String message) =>
      _show(context, message, AppTheme.accent);

  static void info(BuildContext context, String message) =>
      _show(context, message, null);

  /// A snackbar in any [color].
  static void show(BuildContext context, String message, Color color) =>
      _show(context, message, color);

  static void _show(BuildContext context, String message, Color? color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }
}
