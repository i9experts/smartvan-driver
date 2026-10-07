// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartVan Driver';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonNoInternet =>
      'No internet connection. Please check your network and try again.';

  @override
  String get commonServerTrouble =>
      'Server is having trouble right now. Please try again shortly.';

  @override
  String get commonSomethingWrong => 'Something went wrong. Please try again.';

  @override
  String get commonSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get commonUploadFailed => 'Image upload failed. Please try again.';

  @override
  String get commonLoginFailed => 'Login failed. Please try again.';
}
