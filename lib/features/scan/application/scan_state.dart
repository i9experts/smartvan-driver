import 'package:freezed_annotation/freezed_annotation.dart';
import '../../passengers/data/models/scan_result.dart';

part 'scan_state.freezed.dart';

/// What happened to the last card shown to the camera. The screen turns it
/// into localized text and colours.
sealed class ScanOutcome {
  const ScanOutcome();
}

/// The QR is not a SmartVan card (never sent to the server).
class ScanNotACard extends ScanOutcome {
  const ScanNotACard();
}

/// No trip is being tracked on this phone.
class ScanNoActiveTrip extends ScanOutcome {
  const ScanNoActiveTrip();
}

/// The server picked up or dropped a kid.
class ScanSucceeded extends ScanOutcome {
  const ScanSucceeded(this.result);
  final ScanResult result;
}

/// The phone is offline; scanning needs a connection.
class ScanOffline extends ScanOutcome {
  const ScanOffline();
}

/// The server (or the network layer) refused: [code] is the backend code
/// (`INVALID_QR`, `KID_NOT_ON_TRIP`, ...), [error] the original exception.
class ScanFailed extends ScanOutcome {
  const ScanFailed(this.code, this.error);
  final String? code;
  final Object error;
}

@freezed
abstract class ScanState with _$ScanState {
  const factory ScanState({
    /// A scan request is in flight.
    @Default(false) bool busy,

    /// Shown for a few seconds, then cleared.
    ScanOutcome? outcome,

    /// Kids picked up / dropped during this visit to the screen.
    @Default(<ScanResult>[]) List<ScanResult> session,
  }) = _ScanState;
}
