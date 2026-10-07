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

  @override
  String get splashTagline => 'Safe Ride, Every Side';

  @override
  String get loginPortal => 'Driver Portal';

  @override
  String get loginWelcome => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Sign in to manage your trips';

  @override
  String get loginIdLabel => 'Phone Number or CNIC';

  @override
  String get loginIdHint => 'e.g. 03211181555 or your CNIC';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginFillAll => 'Please fill in all fields';
}
