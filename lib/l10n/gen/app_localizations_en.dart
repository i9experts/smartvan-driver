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

  @override
  String get statsTitle => 'My driving stats';

  @override
  String statsDaysOption(int count) {
    return '$count days';
  }

  @override
  String get statsLoadFailed => 'Could not load your stats.';

  @override
  String get statsSafetyScore => 'Safety score';

  @override
  String get statsNoOverspeed => 'No overspeeding — great job!';

  @override
  String statsOverspeedEvents(int count, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overspeed events (limit $limit km/h)',
      one: '1 overspeed event (limit $limit km/h)',
    );
    return '$_temp0';
  }

  @override
  String statsOverspeedEventsNoLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overspeed events',
      one: '1 overspeed event',
    );
    return '$_temp0';
  }

  @override
  String get statsTrips => 'Trips';

  @override
  String get statsDistance => 'Distance';

  @override
  String get statsDrivingTime => 'Driving time';

  @override
  String get statsOnTimeStarts => 'On-time starts';

  @override
  String get statsDropOffs => 'Drop-offs';

  @override
  String get statsTopSpeed => 'Top speed';

  @override
  String statsKm(String value) {
    return '$value km';
  }

  @override
  String statsKmh(String value) {
    return '$value km/h';
  }

  @override
  String statsPercent(String value) {
    return '$value%';
  }

  @override
  String statsDurationHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String statsDurationM(int minutes) {
    return '${minutes}m';
  }

  @override
  String get checklistTitle => 'Daily van check';

  @override
  String get checklistIntro => 'Check each item before your first trip today.';

  @override
  String get checklistOk => 'OK';

  @override
  String get checklistIssue => 'Issue';

  @override
  String get checklistNoteHint => 'What is the problem? (optional)';

  @override
  String get checklistPhotoAdded => 'Photo added';

  @override
  String get checklistAddPhoto => 'Add a photo (optional)';

  @override
  String get checklistPhotoHelp => 'Helpful when reporting an issue';

  @override
  String get checklistRetake => 'Retake';

  @override
  String get checklistTake => 'Take';

  @override
  String get checklistTryAgain => 'Try again';

  @override
  String get checklistLoadFailed => 'Could not load the checklist.';

  @override
  String get checklistSaveFailed => 'Could not save the checklist.';

  @override
  String get checklistPhotoFailedTitle => 'Photo could not be uploaded';

  @override
  String get checklistPhotoFailedBody =>
      'Submit the van check without the photo?';

  @override
  String get checklistSubmitWithoutPhoto => 'Submit without photo';

  @override
  String checklistAnswerAll(int answered, int total) {
    return 'Answer all items ($answered/$total)';
  }

  @override
  String checklistSubmitIssues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Submit and report $count issues',
      one: 'Submit and report 1 issue',
    );
    return '$_temp0';
  }

  @override
  String get checklistSubmitOk => 'Submit — all OK';

  @override
  String get checklistSavedIssues =>
      'Checklist saved. The school has been told about the issues.';

  @override
  String get checklistSavedOk => 'Checklist saved. Safe driving!';

  @override
  String get chatMessagesTitle => 'Messages';

  @override
  String get chatEmpty =>
      'No messages yet.\nOpen a student in Passengers to message their parent.';

  @override
  String get chatLoadFailed => 'Could not load messages.';

  @override
  String get chatSendFailed => 'Message not sent. Try again.';

  @override
  String get chatTypeMessage => 'Type a message';

  @override
  String get chatQuickArriving5 => 'Arriving in 5 minutes.';

  @override
  String get chatQuickAtPickup => 'I am at the pickup point.';

  @override
  String get chatQuickSendOut => 'Please send your child out.';

  @override
  String get chatQuickRunningLate => 'Running about 10 minutes late.';

  @override
  String get chatQuickTraffic => 'Stuck in traffic, will be there soon.';

  @override
  String get chatQuickNotAtStop =>
      'Your child is not at the pickup point. Please call me.';

  @override
  String get scanTitle => 'Scan student card';

  @override
  String get scanTorch => 'Torch';

  @override
  String get scanHintFirst => 'Point the camera at the student\'s QR card.';

  @override
  String scanHintSession(int count) {
    return '$count scanned this session. Keep scanning.';
  }

  @override
  String get scanNotACardTitle => 'Not a SmartVan card';

  @override
  String get scanNotACardBody => 'Scan the student\'s SmartVan QR card.';

  @override
  String get scanNoTripTitle => 'No active trip';

  @override
  String get scanNoTripBody => 'Start a trip before scanning.';

  @override
  String get scanPickedUp => 'Picked up';

  @override
  String get scanDroppedOff => 'Dropped off';

  @override
  String get scanErrInvalidQr => 'Card not recognised';

  @override
  String get scanErrKidNotOnTrip => 'Not on this van';

  @override
  String get scanErrAlreadyPicked => 'Already picked up';

  @override
  String get scanErrAlreadyDropped => 'Already dropped';

  @override
  String get scanErrLocationRequired => 'GPS needed';

  @override
  String get scanErrTripNotOngoing => 'Trip not in progress';

  @override
  String get scanErrNoInternetTitle => 'No internet';

  @override
  String get scanErrNoInternetBody =>
      'No internet. Scanning needs a connection — use the Passengers list instead (it works offline).';

  @override
  String get scanErrDefaultTitle => 'Scan failed';

  @override
  String get scanErrDefaultBody => 'Scan failed. Try again.';

  @override
  String get scanCameraPermission =>
      'Camera permission is needed to scan cards. Enable it in app settings.';

  @override
  String scanCameraFailed(String code) {
    return 'Camera could not start ($code).';
  }

  @override
  String get scanStudentFallback => 'Student';

  @override
  String get passengersTitle => 'Passengers';

  @override
  String get passengersTotal => 'Total';

  @override
  String get passengersPickedLabel => 'Picked';

  @override
  String get passengersRemaining => 'Remaining';

  @override
  String get passengersErrorTitle => 'Couldn\'t Load Passengers';

  @override
  String get passengersErrorBody => 'Check your connection and try again';

  @override
  String get passengersEmptyTitle => 'No Passengers';

  @override
  String get passengersEmptyBody => 'No students assigned to this trip';

  @override
  String get passengersUnknownKid => 'Unknown';

  @override
  String passengersAway(String distance) {
    return '$distance Away';
  }

  @override
  String get passengersSavedOffline => 'Saved offline — waiting to sync';

  @override
  String get passengersMessageParent => 'Message parent';

  @override
  String get passengersStatusDropped => 'Dropped';

  @override
  String get passengersStatusPicked => 'Picked';

  @override
  String get passengersDropButton => 'Drop';

  @override
  String get passengersPickUp => 'Pick Up';

  @override
  String passengersAbsentWithNote(String note) {
    return 'Absent today — $note';
  }

  @override
  String get passengersAbsentNoNote => 'Absent today (parent informed)';

  @override
  String get passengersNotAtStop => 'Not at stop — moved on';

  @override
  String get passengersAtHome => 'At home — tell parent';

  @override
  String get passengersAtStop => 'At stop — tell parent';

  @override
  String passengersWaiting(int minutes, String seconds) {
    return 'Waiting $minutes:$seconds';
  }

  @override
  String get passengersNotHere => 'Not here — move on';

  @override
  String passengersNoShowTitle(String name) {
    return '$name not at stop?';
  }

  @override
  String get passengersNoShowBody =>
      'The parent will be told the van moved on.';

  @override
  String get passengersNoShowHint => 'Note (optional)';

  @override
  String get passengersKeepWaiting => 'Keep waiting';

  @override
  String get passengersMoveOn => 'Move on';

  @override
  String get passengersStudentFallback => 'Student';

  @override
  String get passengersAbsentDialogTitle => 'Marked absent';

  @override
  String passengersAbsentDialogBody(String name) {
    return '$name\'s parent said they are absent today. Pick up anyway?';
  }

  @override
  String get passengersThisStudent => 'This student';

  @override
  String get passengersPickUpConfirm => 'Pick up';

  @override
  String get passengersParentTold => 'Parent told the van is at the stop.';

  @override
  String get passengersTellFailed => 'Could not notify the parent.';

  @override
  String get passengersNoShowFailed => 'Could not mark as not at stop.';

  @override
  String passengersPickedOk(String name) {
    return '$name picked up!';
  }

  @override
  String passengersPickedOffline(String name) {
    return '$name picked up — saved offline, will sync automatically.';
  }

  @override
  String get passengersPickFailed => 'Failed to pick student';

  @override
  String passengersDroppedOk(String name) {
    return '$name dropped off!';
  }

  @override
  String passengersDroppedOffline(String name) {
    return '$name dropped off — saved offline, will sync automatically.';
  }

  @override
  String passengersDropFailed(String name) {
    return 'Failed to drop off $name. Please try again.';
  }

  @override
  String get passengersNoGps =>
      'Could not get your GPS location. Turn on location and try again.';

  @override
  String get passengersChatFailed => 'Could not open chat.';

  @override
  String passengersAbsentEvent(String name) {
    return '$name is absent today (parent informed).';
  }

  @override
  String passengersRidesAfterAll(String name) {
    return '$name will ride today after all.';
  }

  @override
  String get passengersAStudent => 'A student';

  @override
  String get kidProfileTitle => 'Kid Profile';

  @override
  String get kidProfileStudentInfo => 'Student Information';

  @override
  String get kidProfileSchool => 'School';

  @override
  String get kidProfileGrade => 'Grade';

  @override
  String get kidProfileParentContact => 'Parent Contact';

  @override
  String get kidProfilePhone => 'Phone Number';

  @override
  String get kidProfileAltPhone => 'Alternate Phone';

  @override
  String get kidProfileHomeAddress => 'Home Address';

  @override
  String get kidProfileCallParent => 'Call Parent';

  @override
  String get kidProfileDefaultLocation => 'Karachi, Pakistan';

  @override
  String get kidProfileNotFound => 'Student not found';

  @override
  String get tripDefaultName => 'Morning Trip';

  @override
  String get tripShiftMorning => 'Morning';

  @override
  String get tripShiftAfternoon => 'Afternoon';

  @override
  String get tripDriverFallback => 'Driver';

  @override
  String tripSchoolRoute(String route) {
    return 'School Route: $route';
  }

  @override
  String get tripLive => 'Live';

  @override
  String get tripOffline => 'Offline';

  @override
  String tripPassengersCount(int count) {
    return '$count Passengers';
  }

  @override
  String tripPassCount(int count) {
    return '$count Pass.';
  }

  @override
  String get tripStatDate => 'Date';

  @override
  String get tripStatShift => 'Shift';

  @override
  String get tripStatPicked => 'Picked';

  @override
  String get tripMapYourLocation => 'Your Location';

  @override
  String get tripEndTrip => 'End Trip';

  @override
  String get tripEndConfirm => 'Are you sure you want to end this trip?';

  @override
  String get tripEndedForced => 'Trip ended. The school has been alerted.';

  @override
  String get tripEndedOk => 'Trip ended successfully!';

  @override
  String get tripEndFailed => 'Failed to end trip.';

  @override
  String tripPendingSync(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count pickup/drop updates not synced yet. Connect to the internet, wait for sync, then end the trip.',
      one:
          '1 pickup/drop update not synced yet. Connect to the internet, wait for sync, then end the trip.',
    );
    return '$_temp0';
  }

  @override
  String get tripLocationOff =>
      'Location sharing is off — parents can\'t see the van.';

  @override
  String get tripTurnOn => 'Turn on';

  @override
  String tripSavedOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count updates saved offline — will sync automatically.',
      one: '1 update saved offline — will sync automatically.',
    );
    return '$_temp0';
  }

  @override
  String get tripLocationServicesOff =>
      'Please enable location services to share your trip.';

  @override
  String get tripPermissionDenied =>
      'Location permission is needed to share your trip with parents.';

  @override
  String get tripPermissionForever =>
      'Location permission permanently denied. Enable it in app settings.';

  @override
  String get tripPassengersLoadFailed => 'Failed to load passengers';

  @override
  String get tripNotFound => 'Trip not found';

  @override
  String get tripBackHome => 'Back to home';

  @override
  String kidsNotDroppedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students are still marked in the van',
      one: '1 student is still marked in the van',
    );
    return '$_temp0';
  }

  @override
  String get kidsNotDroppedCheckSeats =>
      'Please check every seat before ending the trip.';

  @override
  String get kidsNotDroppedStudent => 'Student';

  @override
  String get kidsNotDroppedGoToPassengers => 'Go to passengers and drop them';

  @override
  String get kidsNotDroppedNotInVan =>
      'They are not in the van — end trip anyway';

  @override
  String get kidsNotDroppedChecked =>
      'I have checked the whole van and no child is inside.';

  @override
  String get kidsNotDroppedWhatHappened => 'What happened? (required)';

  @override
  String get kidsNotDroppedExample => 'e.g. Parent picked him up from school';

  @override
  String get kidsNotDroppedAlertInfo =>
      'The school will be alerted, and these parents will be told the drop was not confirmed.';

  @override
  String get kidsNotDroppedEndAlert => 'End trip and alert school';

  @override
  String get sosButtonLabel => 'SOS';

  @override
  String get sosSemantics => 'SOS. Press and hold to send an emergency alert';

  @override
  String get sosHoldHint => 'Press and hold SOS to send an emergency alert.';

  @override
  String get sosNoLocationTitle => 'Could not get your location';

  @override
  String get sosNoLocationBody =>
      'Turn on GPS and try again, or call for help directly.';

  @override
  String get sosSentTitle => 'SOS sent';

  @override
  String sosSentBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The school has your location. $count parents notified.',
      one: 'The school has your location. 1 parent notified.',
      zero: 'The school has your location.',
    );
    return '$_temp0';
  }

  @override
  String get sosAlreadyTitle => 'SOS already sent';

  @override
  String get sosFailedTitle => 'SOS could not be sent';

  @override
  String sosFailedBody(String message) {
    return '$message\nCall for help directly:';
  }

  @override
  String get sosPolice => 'Police';

  @override
  String get sosRescue => 'Rescue';

  @override
  String get sosEdhi => 'Edhi';

  @override
  String get homeGreetingMorning => 'Good Morning,';

  @override
  String get homeGreetingAfternoon => 'Good Afternoon,';

  @override
  String get homeGreetingEvening => 'Good Evening,';

  @override
  String get homeDriverFallback => 'Driver';

  @override
  String get homeMessages => 'Messages';

  @override
  String get homeDefaultLocation => 'Karachi, Pakistan';

  @override
  String get homeStatTrips => 'Trips Today';

  @override
  String get homeStatPassengers => 'Passengers';

  @override
  String get homeStatCompleted => 'Completed';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavAlerts => 'Alerts';

  @override
  String get homeNavProfile => 'Profile';

  @override
  String get homeTripInProgress => 'Trip in progress';

  @override
  String get homeChecklistNotDone => 'Daily van check not done';

  @override
  String get homeChecklistDone => 'Van check done';

  @override
  String get homeChecklistDoneIssues => 'Van check done — issues reported';

  @override
  String get homeChecklistRequired => 'Required before you can start a trip';

  @override
  String get homeChecklistQuick => 'Takes less than a minute';

  @override
  String get homeChecklistUpdate => 'Tap to update';

  @override
  String get homeDocLicence => 'Driving licence';

  @override
  String get homeDocVehicleCard => 'Vehicle card';

  @override
  String homeDocExpired(String doc) {
    return '$doc expired';
  }

  @override
  String homeDocExpiresToday(String doc) {
    return '$doc expires today';
  }

  @override
  String homeDocExpiresIn(String doc, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$doc expires in $days days',
      one: '$doc expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String homeDocBanner(String text) {
    return '$text. Tap to upload the renewed copy.';
  }

  @override
  String get homeMyRouteToday => 'My Route Today';

  @override
  String get homeTodaysTrips => 'Today\'s Trips';

  @override
  String homeTripsCount(int count) {
    return '$count trips';
  }

  @override
  String get homeRouteFallback => 'Route';

  @override
  String get homeRouteInProgress => 'In Progress';

  @override
  String get homeRouteNotStarted => 'Not Started';

  @override
  String get homeRouteDrop => 'Drop';

  @override
  String get homeRoutePickUp => 'Pick Up';

  @override
  String homeRoutePassengers(int count) {
    return 'Passengers ($count)';
  }

  @override
  String get homeRouteNoStudents => 'No students on this route yet.';

  @override
  String homeGrade(String grade) {
    return 'Grade $grade';
  }

  @override
  String get homeStartTrip => 'Start Trip';

  @override
  String homeAvailableAt(String time) {
    return 'Available at $time';
  }

  @override
  String get homeContinueTrip => 'Continue Trip';

  @override
  String get homeUnknownKid => 'Unknown';

  @override
  String get homeEmptyTitle => 'No Trip Today';

  @override
  String get homeEmptyBody =>
      'No active trips have been assigned\nto you today. Check back later.';

  @override
  String get homeEmptyNotified => 'You\'ll be notified when assigned';

  @override
  String get homeTripFallback => 'School Trip';

  @override
  String get homeTripDropOff => 'Drop Off';

  @override
  String get homeTripPickUp => 'Pick Up';

  @override
  String get homeTripActive => 'Active';

  @override
  String get homeTripCompleted => 'Completed';

  @override
  String get homeTripStarting => 'Starting';

  @override
  String get homeViewTrip => 'View Trip';

  @override
  String get homeStartFailed => 'Failed to start trip. Please try again.';

  @override
  String get homeChecklistFirst => 'Please complete today\'s van check first.';

  @override
  String get homeTripResumed =>
      'Your ongoing trip was resumed — location sharing is on.';
}
