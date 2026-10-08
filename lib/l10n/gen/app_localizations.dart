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

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// No description provided for @alertsSend.
  ///
  /// In en, this message translates to:
  /// **'Send Alert'**
  String get alertsSend;

  /// No description provided for @alertsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t Load Alerts'**
  String get alertsLoadErrorTitle;

  /// No description provided for @alertsLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get alertsLoadErrorBody;

  /// No description provided for @alertsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Alerts'**
  String get alertsEmptyTitle;

  /// No description provided for @alertsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No alerts at the moment'**
  String get alertsEmptyBody;

  /// No description provided for @alertsDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alertsDefaultTitle;

  /// No description provided for @alertsMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String alertsMinutesAgo(int count);

  /// No description provided for @alertsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String alertsHoursAgo(int count);

  /// No description provided for @alertsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String alertsDaysAgo(int count);

  /// No description provided for @alertsSendSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type a message for your school admin.'**
  String get alertsSendSheetSubtitle;

  /// No description provided for @alertsMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your message...'**
  String get alertsMessageHint;

  /// No description provided for @alertsTypeMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Type a message first.'**
  String get alertsTypeMessageFirst;

  /// No description provided for @alertsSent.
  ///
  /// In en, this message translates to:
  /// **'Alert sent to your school admin!'**
  String get alertsSent;

  /// No description provided for @alertsSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send alert.'**
  String get alertsSendFailed;

  /// No description provided for @alertDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert Details'**
  String get alertDetailTitle;

  /// No description provided for @alertTitleEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get alertTitleEmergency;

  /// No description provided for @alertTitlePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment Alert'**
  String get alertTitlePayment;

  /// No description provided for @alertTitleTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip Update'**
  String get alertTitleTrip;

  /// No description provided for @alertTitleProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile Update'**
  String get alertTitleProfile;

  /// No description provided for @alertDetailTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get alertDetailTripDetails;

  /// No description provided for @alertDetailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get alertDetailDate;

  /// No description provided for @alertDetailShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get alertDetailShift;

  /// No description provided for @alertDetailStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get alertDetailStartTime;

  /// No description provided for @alertDetailViewTrip.
  ///
  /// In en, this message translates to:
  /// **'View Trip'**
  String get alertDetailViewTrip;

  /// No description provided for @alertNotFound.
  ///
  /// In en, this message translates to:
  /// **'Alert not found'**
  String get alertNotFound;

  /// No description provided for @feesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee Collection'**
  String get feesTitle;

  /// No description provided for @feesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load students. Pull down to try again.'**
  String get feesLoadFailed;

  /// No description provided for @feesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No students assigned to your van yet.'**
  String get feesEmpty;

  /// No description provided for @feesSummaryHeading.
  ///
  /// In en, this message translates to:
  /// **'This month · {paid}/{students} paid'**
  String feesSummaryHeading(int paid, int students);

  /// No description provided for @feesCollectedByYou.
  ///
  /// In en, this message translates to:
  /// **'Collected by you'**
  String get feesCollectedByYou;

  /// No description provided for @feesPaidOnline.
  ///
  /// In en, this message translates to:
  /// **'Paid online'**
  String get feesPaidOnline;

  /// No description provided for @feesPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get feesPending;

  /// No description provided for @feesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get feesConfirmTitle;

  /// No description provided for @feesConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Mark {name}\'s transport fee as paid (cash collected)?'**
  String feesConfirmBody(String name);

  /// No description provided for @feesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get feesConfirm;

  /// No description provided for @feesPaymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded for {name}'**
  String feesPaymentRecorded(String name);

  /// No description provided for @feesPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to record payment.'**
  String get feesPaymentFailed;

  /// No description provided for @feesStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feesStatusPaid;

  /// No description provided for @feesStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get feesStatusOverdue;

  /// No description provided for @feesStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get feesStatusPending;

  /// No description provided for @feesStatusNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Not Set Up'**
  String get feesStatusNotSetUp;

  /// No description provided for @feesGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String feesGrade(String grade);

  /// No description provided for @feesReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get feesReceipt;

  /// No description provided for @feesMarkPaidCash.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid (Cash)'**
  String get feesMarkPaidCash;

  /// No description provided for @feesUnknownStudent.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get feesUnknownStudent;

  /// No description provided for @receiptDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Transport fee receipt'**
  String get receiptDefaultTitle;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #'**
  String get receiptNumber;

  /// No description provided for @receiptStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get receiptStudent;

  /// No description provided for @receiptGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get receiptGrade;

  /// No description provided for @receiptMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get receiptMonth;

  /// No description provided for @receiptPaidVia.
  ///
  /// In en, this message translates to:
  /// **'Paid via'**
  String get receiptPaidVia;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get receiptDate;

  /// No description provided for @receiptShareWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get receiptShareWhatsApp;

  /// No description provided for @receiptLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the receipt.'**
  String get receiptLoadFailed;

  /// No description provided for @receiptShareTitle.
  ///
  /// In en, this message translates to:
  /// **'🧾 {school} — Transport fee receipt'**
  String receiptShareTitle(String school);

  /// No description provided for @receiptShareNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #: {number}'**
  String receiptShareNumber(String number);

  /// No description provided for @receiptShareStudent.
  ///
  /// In en, this message translates to:
  /// **'Student: {name}'**
  String receiptShareStudent(String name);

  /// No description provided for @receiptShareMonth.
  ///
  /// In en, this message translates to:
  /// **'Month: {month}'**
  String receiptShareMonth(String month);

  /// No description provided for @receiptShareAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String receiptShareAmount(String amount);

  /// No description provided for @receiptSharePaidVia.
  ///
  /// In en, this message translates to:
  /// **'Paid via: {method}'**
  String receiptSharePaidVia(String method);

  /// No description provided for @receiptShareDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String receiptShareDate(String date);

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodJazzcash.
  ///
  /// In en, this message translates to:
  /// **'JazzCash'**
  String get paymentMethodJazzcash;

  /// No description provided for @paymentMethodEasypaisa.
  ///
  /// In en, this message translates to:
  /// **'Easypaisa'**
  String get paymentMethodEasypaisa;

  /// No description provided for @paymentMethodRaast.
  ///
  /// In en, this message translates to:
  /// **'Raast'**
  String get paymentMethodRaast;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'My driving stats'**
  String get statsTitle;

  /// No description provided for @statsDaysOption.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String statsDaysOption(int count);

  /// No description provided for @statsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your stats.'**
  String get statsLoadFailed;

  /// No description provided for @statsSafetyScore.
  ///
  /// In en, this message translates to:
  /// **'Safety score'**
  String get statsSafetyScore;

  /// No description provided for @statsNoOverspeed.
  ///
  /// In en, this message translates to:
  /// **'No overspeeding — great job!'**
  String get statsNoOverspeed;

  /// No description provided for @statsOverspeedEvents.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 overspeed event (limit {limit} km/h)} other{{count} overspeed events (limit {limit} km/h)}}'**
  String statsOverspeedEvents(int count, int limit);

  /// No description provided for @statsOverspeedEventsNoLimit.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 overspeed event} other{{count} overspeed events}}'**
  String statsOverspeedEventsNoLimit(int count);

  /// No description provided for @statsTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get statsTrips;

  /// No description provided for @statsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get statsDistance;

  /// No description provided for @statsDrivingTime.
  ///
  /// In en, this message translates to:
  /// **'Driving time'**
  String get statsDrivingTime;

  /// No description provided for @statsOnTimeStarts.
  ///
  /// In en, this message translates to:
  /// **'On-time starts'**
  String get statsOnTimeStarts;

  /// No description provided for @statsDropOffs.
  ///
  /// In en, this message translates to:
  /// **'Drop-offs'**
  String get statsDropOffs;

  /// No description provided for @statsTopSpeed.
  ///
  /// In en, this message translates to:
  /// **'Top speed'**
  String get statsTopSpeed;

  /// No description provided for @statsKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String statsKm(String value);

  /// No description provided for @statsKmh.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String statsKmh(String value);

  /// No description provided for @statsPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String statsPercent(String value);

  /// No description provided for @statsDurationHm.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String statsDurationHm(int hours, int minutes);

  /// No description provided for @statsDurationM.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String statsDurationM(int minutes);

  /// No description provided for @checklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily van check'**
  String get checklistTitle;

  /// No description provided for @checklistIntro.
  ///
  /// In en, this message translates to:
  /// **'Check each item before your first trip today.'**
  String get checklistIntro;

  /// No description provided for @checklistOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get checklistOk;

  /// No description provided for @checklistIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get checklistIssue;

  /// No description provided for @checklistNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What is the problem? (optional)'**
  String get checklistNoteHint;

  /// No description provided for @checklistPhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get checklistPhotoAdded;

  /// No description provided for @checklistAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo (optional)'**
  String get checklistAddPhoto;

  /// No description provided for @checklistPhotoHelp.
  ///
  /// In en, this message translates to:
  /// **'Helpful when reporting an issue'**
  String get checklistPhotoHelp;

  /// No description provided for @checklistRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get checklistRetake;

  /// No description provided for @checklistTake.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get checklistTake;

  /// No description provided for @checklistTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get checklistTryAgain;

  /// No description provided for @checklistLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the checklist.'**
  String get checklistLoadFailed;

  /// No description provided for @checklistSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the checklist.'**
  String get checklistSaveFailed;

  /// No description provided for @checklistPhotoFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo could not be uploaded'**
  String get checklistPhotoFailedTitle;

  /// No description provided for @checklistPhotoFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Submit the van check without the photo?'**
  String get checklistPhotoFailedBody;

  /// No description provided for @checklistSubmitWithoutPhoto.
  ///
  /// In en, this message translates to:
  /// **'Submit without photo'**
  String get checklistSubmitWithoutPhoto;

  /// No description provided for @checklistAnswerAll.
  ///
  /// In en, this message translates to:
  /// **'Answer all items ({answered}/{total})'**
  String checklistAnswerAll(int answered, int total);

  /// No description provided for @checklistSubmitIssues.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Submit and report 1 issue} other{Submit and report {count} issues}}'**
  String checklistSubmitIssues(int count);

  /// No description provided for @checklistSubmitOk.
  ///
  /// In en, this message translates to:
  /// **'Submit — all OK'**
  String get checklistSubmitOk;

  /// No description provided for @checklistSavedIssues.
  ///
  /// In en, this message translates to:
  /// **'Checklist saved. The school has been told about the issues.'**
  String get checklistSavedIssues;

  /// No description provided for @checklistSavedOk.
  ///
  /// In en, this message translates to:
  /// **'Checklist saved. Safe driving!'**
  String get checklistSavedOk;

  /// No description provided for @chatMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatMessagesTitle;

  /// No description provided for @chatEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.\nOpen a student in Passengers to message their parent.'**
  String get chatEmpty;

  /// No description provided for @chatLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.'**
  String get chatLoadFailed;

  /// No description provided for @chatSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Message not sent. Try again.'**
  String get chatSendFailed;

  /// No description provided for @chatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get chatTypeMessage;

  /// No description provided for @chatQuickArriving5.
  ///
  /// In en, this message translates to:
  /// **'Arriving in 5 minutes.'**
  String get chatQuickArriving5;

  /// No description provided for @chatQuickAtPickup.
  ///
  /// In en, this message translates to:
  /// **'I am at the pickup point.'**
  String get chatQuickAtPickup;

  /// No description provided for @chatQuickSendOut.
  ///
  /// In en, this message translates to:
  /// **'Please send your child out.'**
  String get chatQuickSendOut;

  /// No description provided for @chatQuickRunningLate.
  ///
  /// In en, this message translates to:
  /// **'Running about 10 minutes late.'**
  String get chatQuickRunningLate;

  /// No description provided for @chatQuickTraffic.
  ///
  /// In en, this message translates to:
  /// **'Stuck in traffic, will be there soon.'**
  String get chatQuickTraffic;

  /// No description provided for @chatQuickNotAtStop.
  ///
  /// In en, this message translates to:
  /// **'Your child is not at the pickup point. Please call me.'**
  String get chatQuickNotAtStop;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan student card'**
  String get scanTitle;

  /// No description provided for @scanTorch.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get scanTorch;

  /// No description provided for @scanHintFirst.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the student\'s QR card.'**
  String get scanHintFirst;

  /// No description provided for @scanHintSession.
  ///
  /// In en, this message translates to:
  /// **'{count} scanned this session. Keep scanning.'**
  String scanHintSession(int count);

  /// No description provided for @scanNotACardTitle.
  ///
  /// In en, this message translates to:
  /// **'Not a SmartVan card'**
  String get scanNotACardTitle;

  /// No description provided for @scanNotACardBody.
  ///
  /// In en, this message translates to:
  /// **'Scan the student\'s SmartVan QR card.'**
  String get scanNotACardBody;

  /// No description provided for @scanNoTripTitle.
  ///
  /// In en, this message translates to:
  /// **'No active trip'**
  String get scanNoTripTitle;

  /// No description provided for @scanNoTripBody.
  ///
  /// In en, this message translates to:
  /// **'Start a trip before scanning.'**
  String get scanNoTripBody;

  /// No description provided for @scanPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get scanPickedUp;

  /// No description provided for @scanDroppedOff.
  ///
  /// In en, this message translates to:
  /// **'Dropped off'**
  String get scanDroppedOff;

  /// No description provided for @scanErrInvalidQr.
  ///
  /// In en, this message translates to:
  /// **'Card not recognised'**
  String get scanErrInvalidQr;

  /// No description provided for @scanErrKidNotOnTrip.
  ///
  /// In en, this message translates to:
  /// **'Not on this van'**
  String get scanErrKidNotOnTrip;

  /// No description provided for @scanErrAlreadyPicked.
  ///
  /// In en, this message translates to:
  /// **'Already picked up'**
  String get scanErrAlreadyPicked;

  /// No description provided for @scanErrAlreadyDropped.
  ///
  /// In en, this message translates to:
  /// **'Already dropped'**
  String get scanErrAlreadyDropped;

  /// No description provided for @scanErrLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'GPS needed'**
  String get scanErrLocationRequired;

  /// No description provided for @scanErrTripNotOngoing.
  ///
  /// In en, this message translates to:
  /// **'Trip not in progress'**
  String get scanErrTripNotOngoing;

  /// No description provided for @scanErrNoInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet'**
  String get scanErrNoInternetTitle;

  /// No description provided for @scanErrNoInternetBody.
  ///
  /// In en, this message translates to:
  /// **'No internet. Scanning needs a connection — use the Passengers list instead (it works offline).'**
  String get scanErrNoInternetBody;

  /// No description provided for @scanErrDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get scanErrDefaultTitle;

  /// No description provided for @scanErrDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Try again.'**
  String get scanErrDefaultBody;

  /// No description provided for @scanCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is needed to scan cards. Enable it in app settings.'**
  String get scanCameraPermission;

  /// No description provided for @scanCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'Camera could not start ({code}).'**
  String scanCameraFailed(String code);

  /// No description provided for @scanStudentFallback.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get scanStudentFallback;

  /// No description provided for @passengersTitle.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengersTitle;

  /// No description provided for @passengersTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get passengersTotal;

  /// No description provided for @passengersPickedLabel.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get passengersPickedLabel;

  /// No description provided for @passengersRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get passengersRemaining;

  /// No description provided for @passengersErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t Load Passengers'**
  String get passengersErrorTitle;

  /// No description provided for @passengersErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get passengersErrorBody;

  /// No description provided for @passengersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Passengers'**
  String get passengersEmptyTitle;

  /// No description provided for @passengersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No students assigned to this trip'**
  String get passengersEmptyBody;

  /// No description provided for @passengersUnknownKid.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get passengersUnknownKid;

  /// No description provided for @passengersAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} Away'**
  String passengersAway(String distance);

  /// No description provided for @passengersSavedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved offline — waiting to sync'**
  String get passengersSavedOffline;

  /// No description provided for @passengersMessageParent.
  ///
  /// In en, this message translates to:
  /// **'Message parent'**
  String get passengersMessageParent;

  /// No description provided for @passengersStatusDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get passengersStatusDropped;

  /// No description provided for @passengersStatusPicked.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get passengersStatusPicked;

  /// No description provided for @passengersDropButton.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get passengersDropButton;

  /// No description provided for @passengersPickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick Up'**
  String get passengersPickUp;

  /// No description provided for @passengersAbsentWithNote.
  ///
  /// In en, this message translates to:
  /// **'Absent today — {note}'**
  String passengersAbsentWithNote(String note);

  /// No description provided for @passengersAbsentNoNote.
  ///
  /// In en, this message translates to:
  /// **'Absent today (parent informed)'**
  String get passengersAbsentNoNote;

  /// No description provided for @passengersNotAtStop.
  ///
  /// In en, this message translates to:
  /// **'Not at stop — moved on'**
  String get passengersNotAtStop;

  /// No description provided for @passengersAtHome.
  ///
  /// In en, this message translates to:
  /// **'At home — tell parent'**
  String get passengersAtHome;

  /// No description provided for @passengersAtStop.
  ///
  /// In en, this message translates to:
  /// **'At stop — tell parent'**
  String get passengersAtStop;

  /// No description provided for @passengersWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting {minutes}:{seconds}'**
  String passengersWaiting(int minutes, String seconds);

  /// No description provided for @passengersNotHere.
  ///
  /// In en, this message translates to:
  /// **'Not here — move on'**
  String get passengersNotHere;

  /// No description provided for @passengersNoShowTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} not at stop?'**
  String passengersNoShowTitle(String name);

  /// No description provided for @passengersNoShowBody.
  ///
  /// In en, this message translates to:
  /// **'The parent will be told the van moved on.'**
  String get passengersNoShowBody;

  /// No description provided for @passengersNoShowHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get passengersNoShowHint;

  /// No description provided for @passengersKeepWaiting.
  ///
  /// In en, this message translates to:
  /// **'Keep waiting'**
  String get passengersKeepWaiting;

  /// No description provided for @passengersMoveOn.
  ///
  /// In en, this message translates to:
  /// **'Move on'**
  String get passengersMoveOn;

  /// No description provided for @passengersStudentFallback.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get passengersStudentFallback;

  /// No description provided for @passengersAbsentDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Marked absent'**
  String get passengersAbsentDialogTitle;

  /// No description provided for @passengersAbsentDialogBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s parent said they are absent today. Pick up anyway?'**
  String passengersAbsentDialogBody(String name);

  /// No description provided for @passengersThisStudent.
  ///
  /// In en, this message translates to:
  /// **'This student'**
  String get passengersThisStudent;

  /// No description provided for @passengersPickUpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pick up'**
  String get passengersPickUpConfirm;

  /// No description provided for @passengersParentTold.
  ///
  /// In en, this message translates to:
  /// **'Parent told the van is at the stop.'**
  String get passengersParentTold;

  /// No description provided for @passengersTellFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not notify the parent.'**
  String get passengersTellFailed;

  /// No description provided for @passengersNoShowFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not mark as not at stop.'**
  String get passengersNoShowFailed;

  /// No description provided for @passengersPickedOk.
  ///
  /// In en, this message translates to:
  /// **'{name} picked up!'**
  String passengersPickedOk(String name);

  /// No description provided for @passengersPickedOffline.
  ///
  /// In en, this message translates to:
  /// **'{name} picked up — saved offline, will sync automatically.'**
  String passengersPickedOffline(String name);

  /// No description provided for @passengersPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick student'**
  String get passengersPickFailed;

  /// No description provided for @passengersDroppedOk.
  ///
  /// In en, this message translates to:
  /// **'{name} dropped off!'**
  String passengersDroppedOk(String name);

  /// No description provided for @passengersDroppedOffline.
  ///
  /// In en, this message translates to:
  /// **'{name} dropped off — saved offline, will sync automatically.'**
  String passengersDroppedOffline(String name);

  /// No description provided for @passengersDropFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to drop off {name}. Please try again.'**
  String passengersDropFailed(String name);

  /// No description provided for @passengersNoGps.
  ///
  /// In en, this message translates to:
  /// **'Could not get your GPS location. Turn on location and try again.'**
  String get passengersNoGps;

  /// No description provided for @passengersChatFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open chat.'**
  String get passengersChatFailed;

  /// No description provided for @passengersAbsentEvent.
  ///
  /// In en, this message translates to:
  /// **'{name} is absent today (parent informed).'**
  String passengersAbsentEvent(String name);

  /// No description provided for @passengersRidesAfterAll.
  ///
  /// In en, this message translates to:
  /// **'{name} will ride today after all.'**
  String passengersRidesAfterAll(String name);

  /// No description provided for @passengersAStudent.
  ///
  /// In en, this message translates to:
  /// **'A student'**
  String get passengersAStudent;

  /// No description provided for @kidProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Kid Profile'**
  String get kidProfileTitle;

  /// No description provided for @kidProfileStudentInfo.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get kidProfileStudentInfo;

  /// No description provided for @kidProfileSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get kidProfileSchool;

  /// No description provided for @kidProfileGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get kidProfileGrade;

  /// No description provided for @kidProfileParentContact.
  ///
  /// In en, this message translates to:
  /// **'Parent Contact'**
  String get kidProfileParentContact;

  /// No description provided for @kidProfilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get kidProfilePhone;

  /// No description provided for @kidProfileAltPhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get kidProfileAltPhone;

  /// No description provided for @kidProfileHomeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get kidProfileHomeAddress;

  /// No description provided for @kidProfileCallParent.
  ///
  /// In en, this message translates to:
  /// **'Call Parent'**
  String get kidProfileCallParent;

  /// No description provided for @kidProfileDefaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Karachi, Pakistan'**
  String get kidProfileDefaultLocation;

  /// No description provided for @kidProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Student not found'**
  String get kidProfileNotFound;

  /// No description provided for @tripDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Morning Trip'**
  String get tripDefaultName;

  /// No description provided for @tripShiftMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get tripShiftMorning;

  /// No description provided for @tripShiftAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get tripShiftAfternoon;

  /// No description provided for @tripDriverFallback.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get tripDriverFallback;

  /// No description provided for @tripSchoolRoute.
  ///
  /// In en, this message translates to:
  /// **'School Route: {route}'**
  String tripSchoolRoute(String route);

  /// No description provided for @tripLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get tripLive;

  /// No description provided for @tripOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get tripOffline;

  /// No description provided for @tripPassengersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Passengers'**
  String tripPassengersCount(int count);

  /// No description provided for @tripPassCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Pass.'**
  String tripPassCount(int count);

  /// No description provided for @tripStatDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tripStatDate;

  /// No description provided for @tripStatShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get tripStatShift;

  /// No description provided for @tripStatPicked.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get tripStatPicked;

  /// No description provided for @tripMapYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get tripMapYourLocation;

  /// No description provided for @tripRecenter.
  ///
  /// In en, this message translates to:
  /// **'Re-center'**
  String get tripRecenter;

  /// No description provided for @tripEndTrip.
  ///
  /// In en, this message translates to:
  /// **'End Trip'**
  String get tripEndTrip;

  /// No description provided for @tripEndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end this trip?'**
  String get tripEndConfirm;

  /// No description provided for @tripEndedForced.
  ///
  /// In en, this message translates to:
  /// **'Trip ended. The school has been alerted.'**
  String get tripEndedForced;

  /// No description provided for @tripEndedOk.
  ///
  /// In en, this message translates to:
  /// **'Trip ended successfully!'**
  String get tripEndedOk;

  /// No description provided for @tripEndFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to end trip.'**
  String get tripEndFailed;

  /// No description provided for @tripPendingSync.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pickup/drop update not synced yet. Connect to the internet, wait for sync, then end the trip.} other{{count} pickup/drop updates not synced yet. Connect to the internet, wait for sync, then end the trip.}}'**
  String tripPendingSync(int count);

  /// No description provided for @tripLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Location sharing is off — parents can\'t see the van.'**
  String get tripLocationOff;

  /// No description provided for @tripTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get tripTurnOn;

  /// No description provided for @tripSavedOffline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 update saved offline — will sync automatically.} other{{count} updates saved offline — will sync automatically.}}'**
  String tripSavedOffline(int count);

  /// No description provided for @tripLocationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to share your trip.'**
  String get tripLocationServicesOff;

  /// No description provided for @tripPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to share your trip with parents.'**
  String get tripPermissionDenied;

  /// No description provided for @tripPermissionForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Enable it in app settings.'**
  String get tripPermissionForever;

  /// No description provided for @tripPassengersLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load passengers'**
  String get tripPassengersLoadFailed;

  /// No description provided for @tripNotFound.
  ///
  /// In en, this message translates to:
  /// **'Trip not found'**
  String get tripNotFound;

  /// No description provided for @tripBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get tripBackHome;

  /// No description provided for @kidsNotDroppedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 student is still marked in the van} other{{count} students are still marked in the van}}'**
  String kidsNotDroppedTitle(int count);

  /// No description provided for @kidsNotDroppedCheckSeats.
  ///
  /// In en, this message translates to:
  /// **'Please check every seat before ending the trip.'**
  String get kidsNotDroppedCheckSeats;

  /// No description provided for @kidsNotDroppedStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get kidsNotDroppedStudent;

  /// No description provided for @kidsNotDroppedGoToPassengers.
  ///
  /// In en, this message translates to:
  /// **'Go to passengers and drop them'**
  String get kidsNotDroppedGoToPassengers;

  /// No description provided for @kidsNotDroppedNotInVan.
  ///
  /// In en, this message translates to:
  /// **'They are not in the van — end trip anyway'**
  String get kidsNotDroppedNotInVan;

  /// No description provided for @kidsNotDroppedChecked.
  ///
  /// In en, this message translates to:
  /// **'I have checked the whole van and no child is inside.'**
  String get kidsNotDroppedChecked;

  /// No description provided for @kidsNotDroppedWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened? (required)'**
  String get kidsNotDroppedWhatHappened;

  /// No description provided for @kidsNotDroppedExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Parent picked him up from school'**
  String get kidsNotDroppedExample;

  /// No description provided for @kidsNotDroppedAlertInfo.
  ///
  /// In en, this message translates to:
  /// **'The school will be alerted, and these parents will be told the drop was not confirmed.'**
  String get kidsNotDroppedAlertInfo;

  /// No description provided for @kidsNotDroppedEndAlert.
  ///
  /// In en, this message translates to:
  /// **'End trip and alert school'**
  String get kidsNotDroppedEndAlert;

  /// No description provided for @sosButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButtonLabel;

  /// No description provided for @sosSemantics.
  ///
  /// In en, this message translates to:
  /// **'SOS. Press and hold to send an emergency alert'**
  String get sosSemantics;

  /// No description provided for @sosHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold SOS to send an emergency alert.'**
  String get sosHoldHint;

  /// No description provided for @sosNoLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location'**
  String get sosNoLocationTitle;

  /// No description provided for @sosNoLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on GPS and try again, or call for help directly.'**
  String get sosNoLocationBody;

  /// No description provided for @sosSentTitle.
  ///
  /// In en, this message translates to:
  /// **'SOS sent'**
  String get sosSentTitle;

  /// No description provided for @sosSentBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{The school has your location.} =1{The school has your location. 1 parent notified.} other{The school has your location. {count} parents notified.}}'**
  String sosSentBody(int count);

  /// No description provided for @sosAlreadyTitle.
  ///
  /// In en, this message translates to:
  /// **'SOS already sent'**
  String get sosAlreadyTitle;

  /// No description provided for @sosFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'SOS could not be sent'**
  String get sosFailedTitle;

  /// No description provided for @sosFailedBody.
  ///
  /// In en, this message translates to:
  /// **'{message}\nCall for help directly:'**
  String sosFailedBody(String message);

  /// No description provided for @sosPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get sosPolice;

  /// No description provided for @sosRescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get sosRescue;

  /// No description provided for @sosEdhi.
  ///
  /// In en, this message translates to:
  /// **'Edhi'**
  String get sosEdhi;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get homeGreetingEvening;

  /// No description provided for @homeDriverFallback.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get homeDriverFallback;

  /// No description provided for @homeMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get homeMessages;

  /// No description provided for @homeDefaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Karachi, Pakistan'**
  String get homeDefaultLocation;

  /// No description provided for @homeStatTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips Today'**
  String get homeStatTrips;

  /// No description provided for @homeStatPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get homeStatPassengers;

  /// No description provided for @homeStatCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeStatCompleted;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get homeNavAlerts;

  /// No description provided for @homeNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeNavProfile;

  /// No description provided for @homeTripInProgress.
  ///
  /// In en, this message translates to:
  /// **'Trip in progress'**
  String get homeTripInProgress;

  /// No description provided for @homeChecklistNotDone.
  ///
  /// In en, this message translates to:
  /// **'Daily van check not done'**
  String get homeChecklistNotDone;

  /// No description provided for @homeChecklistDone.
  ///
  /// In en, this message translates to:
  /// **'Van check done'**
  String get homeChecklistDone;

  /// No description provided for @homeChecklistDoneIssues.
  ///
  /// In en, this message translates to:
  /// **'Van check done — issues reported'**
  String get homeChecklistDoneIssues;

  /// No description provided for @homeChecklistRequired.
  ///
  /// In en, this message translates to:
  /// **'Required before you can start a trip'**
  String get homeChecklistRequired;

  /// No description provided for @homeChecklistQuick.
  ///
  /// In en, this message translates to:
  /// **'Takes less than a minute'**
  String get homeChecklistQuick;

  /// No description provided for @homeChecklistUpdate.
  ///
  /// In en, this message translates to:
  /// **'Tap to update'**
  String get homeChecklistUpdate;

  /// No description provided for @homeDocLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving licence'**
  String get homeDocLicence;

  /// No description provided for @homeDocVehicleCard.
  ///
  /// In en, this message translates to:
  /// **'Vehicle card'**
  String get homeDocVehicleCard;

  /// No description provided for @homeDocExpired.
  ///
  /// In en, this message translates to:
  /// **'{doc} expired'**
  String homeDocExpired(String doc);

  /// No description provided for @homeDocExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'{doc} expires today'**
  String homeDocExpiresToday(String doc);

  /// No description provided for @homeDocExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{{doc} expires in 1 day} other{{doc} expires in {days} days}}'**
  String homeDocExpiresIn(String doc, int days);

  /// No description provided for @homeDocBanner.
  ///
  /// In en, this message translates to:
  /// **'{text}. Tap to upload the renewed copy.'**
  String homeDocBanner(String text);

  /// No description provided for @homeMyRouteToday.
  ///
  /// In en, this message translates to:
  /// **'My Route Today'**
  String get homeMyRouteToday;

  /// No description provided for @homeTodaysTrips.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Trips'**
  String get homeTodaysTrips;

  /// No description provided for @homeTripsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} trips'**
  String homeTripsCount(int count);

  /// No description provided for @homeRouteFallback.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get homeRouteFallback;

  /// No description provided for @homeRouteInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get homeRouteInProgress;

  /// No description provided for @homeRouteNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get homeRouteNotStarted;

  /// No description provided for @homeRouteDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get homeRouteDrop;

  /// No description provided for @homeRoutePickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick Up'**
  String get homeRoutePickUp;

  /// No description provided for @homeRoutePassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers ({count})'**
  String homeRoutePassengers(int count);

  /// No description provided for @homeRouteNoStudents.
  ///
  /// In en, this message translates to:
  /// **'No students on this route yet.'**
  String get homeRouteNoStudents;

  /// No description provided for @homeGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String homeGrade(String grade);

  /// No description provided for @homeStartTrip.
  ///
  /// In en, this message translates to:
  /// **'Start Trip'**
  String get homeStartTrip;

  /// No description provided for @homeAvailableAt.
  ///
  /// In en, this message translates to:
  /// **'Available at {time}'**
  String homeAvailableAt(String time);

  /// No description provided for @homeContinueTrip.
  ///
  /// In en, this message translates to:
  /// **'Continue Trip'**
  String get homeContinueTrip;

  /// No description provided for @homeRouteCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed ✓'**
  String get homeRouteCompleted;

  /// No description provided for @homeRouteDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s trip is done'**
  String get homeRouteDoneToday;

  /// No description provided for @homeTripAlreadyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today\'s trip for this route is already completed.'**
  String get homeTripAlreadyCompleted;

  /// No description provided for @homeTripAlreadyStarted.
  ///
  /// In en, this message translates to:
  /// **'This trip has already started. Open it with Continue Trip.'**
  String get homeTripAlreadyStarted;

  /// No description provided for @homeUnknownKid.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get homeUnknownKid;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Trip Today'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No active trips have been assigned\nto you today. Check back later.'**
  String get homeEmptyBody;

  /// No description provided for @homeEmptyNotified.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified when assigned'**
  String get homeEmptyNotified;

  /// No description provided for @homeTripFallback.
  ///
  /// In en, this message translates to:
  /// **'School Trip'**
  String get homeTripFallback;

  /// No description provided for @homeTripDropOff.
  ///
  /// In en, this message translates to:
  /// **'Drop Off'**
  String get homeTripDropOff;

  /// No description provided for @homeTripPickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick Up'**
  String get homeTripPickUp;

  /// No description provided for @homeTripActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeTripActive;

  /// No description provided for @homeTripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeTripCompleted;

  /// No description provided for @homeTripStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get homeTripStarting;

  /// No description provided for @homeViewTrip.
  ///
  /// In en, this message translates to:
  /// **'View Trip'**
  String get homeViewTrip;

  /// No description provided for @homeStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start trip. Please try again.'**
  String get homeStartFailed;

  /// No description provided for @homeChecklistFirst.
  ///
  /// In en, this message translates to:
  /// **'Please complete today\'s van check first.'**
  String get homeChecklistFirst;

  /// No description provided for @homeTripResumed.
  ///
  /// In en, this message translates to:
  /// **'Your ongoing trip was resumed — location sharing is on.'**
  String get homeTripResumed;
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
