import 'package:flutter/material.dart';

/// [base] with the system navigation bar / home indicator height added to its
/// bottom, so the last item of a full-screen scrollable (one that is not under
/// a `SafeArea` or a bottom bar) can scroll up clear of it.
EdgeInsets withBottomInset(BuildContext context, EdgeInsets base) => base
    .copyWith(bottom: base.bottom + MediaQuery.viewPaddingOf(context).bottom);
