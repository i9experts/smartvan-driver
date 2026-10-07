import 'package:flutter/widgets.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n.someString` instead of `AppLocalizations.of(context)`.
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
