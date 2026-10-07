import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title (task switcher, MaterialApp.title).
  ///
  /// In en, this message translates to:
  /// **'SmartVan Driver'**
  String get appTitle;

  /// Button that repeats a failed load.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get commonNoInternet;

  /// No description provided for @commonServerTrouble.
  ///
  /// In en, this message translates to:
  /// **'Server is having trouble right now. Please try again shortly.'**
  String get commonServerTrouble;

  /// No description provided for @commonSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonSomethingWrong;

  /// No description provided for @commonSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get commonSessionExpired;

  /// No description provided for @commonUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed. Please try again.'**
  String get commonUploadFailed;

  /// No description provided for @commonLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get commonLoginFailed;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Safe Ride, Every Side'**
  String get splashTagline;

  /// No description provided for @loginPortal.
  ///
  /// In en, this message translates to:
  /// **'Driver Portal'**
  String get loginPortal;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your trips'**
  String get loginSubtitle;

  /// No description provided for @loginIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number or CNIC'**
  String get loginIdLabel;

  /// No description provided for @loginIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 03211181555 or your CNIC'**
  String get loginIdHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get loginFillAll;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPassword;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// Shown in the logout dialog while pickups/drops are still queued offline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pickup/drop update not synced yet. Logging out now will discard it. Connect to the internet first if possible.} other{{count} pickup/drop updates not synced yet. Logging out now will discard them. Connect to the internet first if possible.}}'**
  String logoutPendingSync(int count);

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadFailed;

  /// No description provided for @profileDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get profileDriver;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileMyProfile;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileAlternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get profileAlternatePhone;

  /// No description provided for @profileCnic.
  ///
  /// In en, this message translates to:
  /// **'CNIC'**
  String get profileCnic;

  /// No description provided for @profileAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddress;

  /// No description provided for @profileVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get profileVehicleDetails;

  /// No description provided for @profileModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get profileModel;

  /// No description provided for @profilePlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get profilePlateNumber;

  /// No description provided for @profileSeats.
  ///
  /// In en, this message translates to:
  /// **'No. of Seats'**
  String get profileSeats;

  /// No description provided for @profileQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get profileQuickActions;

  /// No description provided for @profileDrivingStats.
  ///
  /// In en, this message translates to:
  /// **'My Driving Stats'**
  String get profileDrivingStats;

  /// No description provided for @profileFeeCollection.
  ///
  /// In en, this message translates to:
  /// **'Fee Collection'**
  String get profileFeeCollection;

  /// No description provided for @profileMyDocuments.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get profileMyDocuments;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileReportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get profileReportIssue;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get editProfileChangeImage;

  /// No description provided for @editProfilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfilePhoneNumber;

  /// No description provided for @editProfileCnicNumber.
  ///
  /// In en, this message translates to:
  /// **'CNIC Number'**
  String get editProfileCnicNumber;

  /// No description provided for @editProfileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get editProfileUpdate;

  /// No description provided for @editProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfileUpdated;

  /// No description provided for @editProfileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get editProfileUpdateFailed;

  /// No description provided for @editProfileLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t Load Your Profile'**
  String get editProfileLoadErrorTitle;

  /// No description provided for @editProfileLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Editing is disabled until your current details load, so nothing gets overwritten with blank fields. Check your connection and try again.'**
  String get editProfileLoadErrorBody;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsVehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration Certificate'**
  String get documentsVehicleRegistration;

  /// No description provided for @documentsDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get documentsDrivingLicense;

  /// No description provided for @documentsUploadNew.
  ///
  /// In en, this message translates to:
  /// **'Upload New Document'**
  String get documentsUploadNew;

  /// No description provided for @documentsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get documentsUpload;

  /// No description provided for @documentsUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get documentsUploaded;

  /// No description provided for @documentsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load documents'**
  String get documentsLoadFailed;

  /// No description provided for @documentsUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get documentsUploading;

  /// No description provided for @documentsUploadedOk.
  ///
  /// In en, this message translates to:
  /// **'{name} uploaded successfully!'**
  String documentsUploadedOk(String name);

  /// No description provided for @documentsUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document.'**
  String get documentsUploadFailed;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from the previously used password.'**
  String get changePasswordHint;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordNew.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNew;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordUpdate;

  /// No description provided for @changePasswordFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get changePasswordFillAll;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get changePasswordTooShort;

  /// No description provided for @changePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Try again.'**
  String get changePasswordFailed;

  /// No description provided for @changePasswordDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Updated!'**
  String get changePasswordDoneTitle;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportTitle;

  /// No description provided for @reportSelectIssueType.
  ///
  /// In en, this message translates to:
  /// **'Select Issue Type'**
  String get reportSelectIssueType;

  /// No description provided for @reportIssueVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Issue'**
  String get reportIssueVehicle;

  /// No description provided for @reportIssueRunningLate.
  ///
  /// In en, this message translates to:
  /// **'Running Late'**
  String get reportIssueRunningLate;

  /// No description provided for @reportIssuePassengerNoShow.
  ///
  /// In en, this message translates to:
  /// **'Passenger No-Show'**
  String get reportIssuePassengerNoShow;

  /// No description provided for @reportIssueEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get reportIssueEmergency;

  /// No description provided for @reportIssueTrackingNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Tracking Not Working'**
  String get reportIssueTrackingNotWorking;

  /// No description provided for @reportIssueOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportIssueOther;

  /// No description provided for @reportDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get reportDescription;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'I am facing a mechanical issue and cannot continue the trip.'**
  String get reportDescriptionHint;

  /// No description provided for @reportUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo or Screenshot'**
  String get reportUploadPhoto;

  /// No description provided for @reportUploadPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Helps provide context, like if the van was parked wrongly or driver was rude.'**
  String get reportUploadPhotoHint;

  /// No description provided for @reportUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get reportUpload;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get reportSubmit;

  /// No description provided for @reportDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue'**
  String get reportDescribeIssue;

  /// No description provided for @reportGalleryFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the gallery. Check app permissions.'**
  String get reportGalleryFailed;

  /// No description provided for @reportSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report.'**
  String get reportSubmitFailed;

  /// No description provided for @reportThanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get reportThanksTitle;

  /// No description provided for @reportThanksBody.
  ///
  /// In en, this message translates to:
  /// **'Your concern has been forwarded to the support team. You will be notified once it is resolved.'**
  String get reportThanksBody;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Documents'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No documents to show'**
  String get documentsEmptyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
