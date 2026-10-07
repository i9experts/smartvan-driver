import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/error_text.dart';
import '../../l10n/l10n.dart';
import 'app_states.dart';

/// Renders an [AsyncValue]: spinner while loading, an error view with a
/// retry button, or [data] (docs/ARCHITECTURE.md §6).
///
/// While a refresh is running over existing data the data stays on screen.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.errorFallback,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Shown on the error view's button; omit for no retry.
  final VoidCallback? onRetry;

  /// Screen-specific sentence used when the error carries no message.
  final String? errorFallback;

  /// Replaces the default spinner.
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: true,
      loading: () => loading ?? const AppLoading(),
      error: (error, _) => AppErrorView(
        message: context.errorText(error, fallback: errorFallback),
        onRetry: onRetry,
        retryLabel: onRetry == null ? null : context.l10n.commonRetry,
      ),
      data: data,
    );
  }
}
