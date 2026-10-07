/// Every route path in one place (docs/ARCHITECTURE.md §7). Screens and
/// controllers navigate with these, never with string literals. Ids travel in
/// the path; `extra` may only carry an optional already-loaded model.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';

  static const alerts = '/alerts';
  static const alertDetail = '/alerts/:alertId';
  static String alertDetailOf(String alertId) =>
      '/alerts/${Uri.encodeComponent(alertId)}';

  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const documents = '/documents';
  static const changePassword = '/change-password';
  static const reportIssue = '/report-issue';
  static const stats = '/stats';
  static const feeCollection = '/fee-collection';

  static const chats = '/chats';
  static const chat = '/chat/:conversationId';
  static String chatOf(String conversationId) =>
      '/chat/${Uri.encodeComponent(conversationId)}';

  static const trip = '/trip/:tripId';
  static String tripOf(String tripId) => '/trip/${Uri.encodeComponent(tripId)}';

  static const passengers = '/passengers/:tripId';
  static String passengersOf(String tripId) =>
      '/passengers/${Uri.encodeComponent(tripId)}';

  static const kid = '/kid/:kidId';
  static String kidOf(String kidId) => '/kid/${Uri.encodeComponent(kidId)}';

  /// Optional `?routeId=` — the route whose trip the check is for.
  static const checklist = '/checklist';
  static String checklistOf({String? routeId}) => routeId == null
      ? checklist
      : Uri(path: checklist, queryParameters: {'routeId': routeId}).toString();

  static const scan = '/scan';

  // TODO(R.4 group C): remove once trip / passengers / kid / chat take ids in
  // the path. These still receive their data through `extra`.
  static const legacyTrip = '/trip';
  static const legacyPassengers = '/passengers';
  static const legacyKid = '/kid-profile';
  static const legacyChat = '/chat';
}
