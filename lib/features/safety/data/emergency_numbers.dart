import 'package:url_launcher/url_launcher.dart';

/// Pakistan emergency numbers shown when an SOS can't be sent (or as a
/// follow-up after it is).
class EmergencyNumbers {
  EmergencyNumbers._();
  static const police = '15';
  static const rescue = '1122';
  static const edhi = '115';

  static Future<void> call(String number) async {
    await launchUrl(Uri(scheme: 'tel', path: number));
  }
}
