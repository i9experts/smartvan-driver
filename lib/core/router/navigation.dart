import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension PopOrGo on BuildContext {
  /// Goes back one page when there is one (system back and swipe-back work
  /// because screens are pushed), otherwise — a screen opened without a
  /// stack, e.g. from a link — goes to [fallback].
  void popOrGo(String fallback) {
    if (canPop()) {
      pop();
    } else {
      go(fallback);
    }
  }
}
