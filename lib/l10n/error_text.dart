import 'package:flutter/widgets.dart';
import '../core/network/app_exception.dart';
import 'l10n.dart';

/// The text a user reads for a failure (docs/ARCHITECTURE.md §4, §12).
///
/// Mirrors [AppException.userMessage] but from the ARB files: the server's own
/// message wins when it sent one, otherwise [fallback] (a screen-specific
/// sentence such as "Could not load your stats."), otherwise a generic text.
String errorText(AppLocalizations l10n, Object error, {String? fallback}) {
  final e = AppException.from(error);
  return switch (e) {
    NetworkException() => l10n.commonNoInternet,
    UnauthorizedException(:final serverMessage) =>
      serverMessage ?? l10n.commonSessionExpired,
    ServerException(:final serverMessage) =>
      serverMessage ?? l10n.commonServerTrouble,
    ApiError(:final code, :final message) => switch (code) {
        'NO_TOKEN' => l10n.commonLoginFailed,
        'UPLOAD_FAILED' => l10n.commonUploadFailed,
        _ => message ?? fallback ?? l10n.commonSomethingWrong,
      },
    UnknownException() => fallback ?? l10n.commonSomethingWrong,
  };
}

extension ErrorTextContext on BuildContext {
  /// [errorText] with this context's localizations.
  String errorText(Object error, {String? fallback}) =>
      _errorText(l10n, error, fallback: fallback);
}

String _errorText(AppLocalizations l10n, Object error, {String? fallback}) =>
    errorText(l10n, error, fallback: fallback);
