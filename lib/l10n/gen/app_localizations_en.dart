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

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get commonPassword => 'Password';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String logoutPendingSync(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count pickup/drop updates not synced yet. Logging out now will discard them. Connect to the internet first if possible.',
      one:
          '1 pickup/drop update not synced yet. Logging out now will discard it. Connect to the internet first if possible.',
    );
    return '$_temp0';
  }

  @override
  String get profileLoadFailed => 'Failed to load profile';

  @override
  String get profileDriver => 'Driver';

  @override
  String get profileMyProfile => 'My Profile';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileAlternatePhone => 'Alternate Phone';

  @override
  String get profileCnic => 'CNIC';

  @override
  String get profileAddress => 'Address';

  @override
  String get profileVehicleDetails => 'Vehicle Details';

  @override
  String get profileModel => 'Model';

  @override
  String get profilePlateNumber => 'Plate Number';

  @override
  String get profileSeats => 'No. of Seats';

  @override
  String get profileQuickActions => 'Quick Actions';

  @override
  String get profileDrivingStats => 'My Driving Stats';

  @override
  String get profileFeeCollection => 'Fee Collection';

  @override
  String get profileMyDocuments => 'My Documents';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileReportIssue => 'Report an Issue';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileChangeImage => 'Change Image';

  @override
  String get editProfilePhoneNumber => 'Phone Number';

  @override
  String get editProfileCnicNumber => 'CNIC Number';

  @override
  String get editProfileUpdate => 'Update Profile';

  @override
  String get editProfileUpdated => 'Profile updated successfully!';

  @override
  String get editProfileUpdateFailed => 'Failed to update profile';

  @override
  String get editProfileLoadErrorTitle => 'Couldn\'t Load Your Profile';

  @override
  String get editProfileLoadErrorBody =>
      'Editing is disabled until your current details load, so nothing gets overwritten with blank fields. Check your connection and try again.';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsVehicleRegistration => 'Vehicle Registration Certificate';

  @override
  String get documentsDrivingLicense => 'Driving License';

  @override
  String get documentsUploadNew => 'Upload New Document';

  @override
  String get documentsUpload => 'Upload';

  @override
  String get documentsUploaded => 'Uploaded';

  @override
  String get documentsLoadFailed => 'Failed to load documents';

  @override
  String get documentsUploading => 'Uploading...';

  @override
  String documentsUploadedOk(String name) {
    return '$name uploaded successfully!';
  }

  @override
  String get documentsUploadFailed => 'Failed to upload document.';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordHint =>
      'Your new password must be different from the previously used password.';

  @override
  String get changePasswordCurrent => 'Current Password';

  @override
  String get changePasswordNew => 'New Password';

  @override
  String get changePasswordConfirm => 'Confirm New Password';

  @override
  String get changePasswordUpdate => 'Update Password';

  @override
  String get changePasswordFillAll => 'Please fill in all fields';

  @override
  String get changePasswordMismatch => 'New passwords do not match';

  @override
  String get changePasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get changePasswordFailed => 'Failed to change password. Try again.';

  @override
  String get changePasswordDoneTitle => 'Password Updated!';

  @override
  String get reportTitle => 'Report an Issue';

  @override
  String get reportSelectIssueType => 'Select Issue Type';

  @override
  String get reportIssueVehicle => 'Vehicle Issue';

  @override
  String get reportIssueRunningLate => 'Running Late';

  @override
  String get reportIssuePassengerNoShow => 'Passenger No-Show';

  @override
  String get reportIssueEmergency => 'Emergency';

  @override
  String get reportIssueTrackingNotWorking => 'Tracking Not Working';

  @override
  String get reportIssueOther => 'Other';

  @override
  String get reportDescription => 'Description';

  @override
  String get reportDescriptionHint =>
      'I am facing a mechanical issue and cannot continue the trip.';

  @override
  String get reportUploadPhoto => 'Upload Photo or Screenshot';

  @override
  String get reportUploadPhotoHint =>
      'Helps provide context, like if the van was parked wrongly or driver was rude.';

  @override
  String get reportUpload => 'Upload';

  @override
  String get reportSubmit => 'Submit';

  @override
  String get reportDescribeIssue => 'Please describe the issue';

  @override
  String get reportGalleryFailed =>
      'Couldn\'t open the gallery. Check app permissions.';

  @override
  String get reportSubmitFailed => 'Failed to submit report.';

  @override
  String get reportThanksTitle => 'Thank you for your feedback!';

  @override
  String get reportThanksBody =>
      'Your concern has been forwarded to the support team. You will be notified once it is resolved.';

  @override
  String get profileLogout => 'Logout';

  @override
  String get documentsEmptyTitle => 'No Documents';

  @override
  String get documentsEmptyBody => 'No documents to show';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get alertsSend => 'Send Alert';

  @override
  String get alertsLoadErrorTitle => 'Couldn\'t Load Alerts';

  @override
  String get alertsLoadErrorBody => 'Check your connection and try again';

  @override
  String get alertsEmptyTitle => 'No Alerts';

  @override
  String get alertsEmptyBody => 'No alerts at the moment';

  @override
  String get alertsDefaultTitle => 'Alert';

  @override
  String alertsMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String alertsHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String alertsDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get alertsSendSheetSubtitle => 'Type a message for your school admin.';

  @override
  String get alertsMessageHint => 'Enter your message...';

  @override
  String get alertsTypeMessageFirst => 'Type a message first.';

  @override
  String get alertsSent => 'Alert sent to your school admin!';

  @override
  String get alertsSendFailed => 'Failed to send alert.';

  @override
  String get alertDetailTitle => 'Alert Details';

  @override
  String get alertTitleEmergency => 'Emergency Alert';

  @override
  String get alertTitlePayment => 'Payment Alert';

  @override
  String get alertTitleTrip => 'Trip Update';

  @override
  String get alertTitleProfile => 'Profile Update';

  @override
  String get alertDetailTripDetails => 'Trip Details';

  @override
  String get alertDetailDate => 'Date';

  @override
  String get alertDetailShift => 'Shift';

  @override
  String get alertDetailStartTime => 'Start Time';

  @override
  String get alertDetailViewTrip => 'View Trip';

  @override
  String get alertNotFound => 'Alert not found';

  @override
  String get feesTitle => 'Fee Collection';

  @override
  String get feesLoadFailed =>
      'Could not load students. Pull down to try again.';

  @override
  String get feesEmpty => 'No students assigned to your van yet.';

  @override
  String feesSummaryHeading(int paid, int students) {
    return 'This month · $paid/$students paid';
  }

  @override
  String get feesCollectedByYou => 'Collected by you';

  @override
  String get feesPaidOnline => 'Paid online';

  @override
  String get feesPending => 'Pending';

  @override
  String get feesConfirmTitle => 'Confirm Payment';

  @override
  String feesConfirmBody(String name) {
    return 'Mark $name\'s transport fee as paid (cash collected)?';
  }

  @override
  String get feesConfirm => 'Confirm';

  @override
  String feesPaymentRecorded(String name) {
    return 'Payment recorded for $name';
  }

  @override
  String get feesPaymentFailed => 'Failed to record payment.';

  @override
  String get feesStatusPaid => 'Paid';

  @override
  String get feesStatusOverdue => 'Overdue';

  @override
  String get feesStatusPending => 'Pending';

  @override
  String get feesStatusNotSetUp => 'Not Set Up';

  @override
  String feesGrade(String grade) {
    return 'Grade $grade';
  }

  @override
  String get feesReceipt => 'Receipt';

  @override
  String get feesMarkPaidCash => 'Mark as Paid (Cash)';

  @override
  String get feesUnknownStudent => 'Unknown';

  @override
  String get receiptDefaultTitle => 'Transport fee receipt';

  @override
  String get receiptNumber => 'Receipt #';

  @override
  String get receiptStudent => 'Student';

  @override
  String get receiptGrade => 'Grade';

  @override
  String get receiptMonth => 'Month';

  @override
  String get receiptPaidVia => 'Paid via';

  @override
  String get receiptDate => 'Date';

  @override
  String get receiptShareWhatsApp => 'Share on WhatsApp';

  @override
  String get receiptLoadFailed => 'Could not load the receipt.';

  @override
  String receiptShareTitle(String school) {
    return '🧾 $school — Transport fee receipt';
  }

  @override
  String receiptShareNumber(String number) {
    return 'Receipt #: $number';
  }

  @override
  String receiptShareStudent(String name) {
    return 'Student: $name';
  }

  @override
  String receiptShareMonth(String month) {
    return 'Month: $month';
  }

  @override
  String receiptShareAmount(String amount) {
    return 'Amount: $amount';
  }

  @override
  String receiptSharePaidVia(String method) {
    return 'Paid via: $method';
  }

  @override
  String receiptShareDate(String date) {
    return 'Date: $date';
  }

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodJazzcash => 'JazzCash';

  @override
  String get paymentMethodEasypaisa => 'Easypaisa';

  @override
  String get paymentMethodRaast => 'Raast';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodOther => 'Other';
}
