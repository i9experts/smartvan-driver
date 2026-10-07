import 'package:flutter/material.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/l10n.dart';

/// Shown when the current profile could not be loaded: editing stays
/// disabled so nothing is overwritten with blank fields.
class EditProfileLoadError extends StatelessWidget {
  const EditProfileLoadError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LoadErrorView(
      title: l10n.editProfileLoadErrorTitle,
      message: l10n.editProfileLoadErrorBody,
      retryLabel: l10n.commonRetry,
      onRetry: onRetry,
    );
  }
}
