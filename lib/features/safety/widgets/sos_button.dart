import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_errors.dart';
import '../../trip/application/trip_tracking.dart';
import '../sos_service.dart';

/// Red SOS button. Must be held for [_holdDuration] to fire, so it can't be
/// triggered by an accidental tap while driving.
class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key});

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton>
    with SingleTickerProviderStateMixin {
  static const _holdDuration = Duration(milliseconds: 1500);
  static const _red = Color(0xFFE53935);

  late final AnimationController _hold =
      AnimationController(vsync: this, duration: _holdDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _send();
        });
  bool _sending = false;

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  void _startHold() {
    if (_sending) return;
    HapticFeedback.mediumImpact();
    _hold.forward(from: 0);
  }

  void _cancelHold() {
    if (_hold.status != AnimationStatus.completed) _hold.reverse();
  }

  Future<void> _send() async {
    if (_sending) return;
    setState(() => _sending = true);
    HapticFeedback.heavyImpact();
    try {
      final tracking = ref.read(tripTrackingProvider);
      final position =
          await ref.read(tripTrackingProvider.notifier).currentPosition();
      if (position == null) {
        _showResult(
          ok: false,
          title: 'Could not get your location',
          body: 'Turn on GPS and try again, or call for help directly.',
        );
        return;
      }
      final parents = await SosService.send(
        tripId: tracking.tripId,
        lat: position.lat,
        lng: position.lng,
      );
      _showResult(
        ok: true,
        title: 'SOS sent',
        body: 'The school has your location.'
            '${parents > 0 ? ' $parents parent${parents == 1 ? '' : 's'} notified.' : ''}',
      );
    } catch (e) {
      final rateLimited = ApiErrors.code(e) == 'SOS_RATE_LIMITED';
      _showResult(
        ok: rateLimited,
        title: rateLimited ? 'SOS already sent' : 'SOS could not be sent',
        body: rateLimited
            ? ApiErrors.message(e)
            : '${ApiErrors.message(e)}\nCall for help directly:',
      );
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _hold.reset();
      }
    }
  }

  void _showResult(
      {required bool ok, required String title, required String body}) {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(ok ? Icons.check_circle : Icons.error,
                  color: ok ? const Color(0xFF27AE60) : _red, size: 48),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 6),
              Text(body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              Row(
                children: [
                  _callButton('Police', EmergencyNumbers.police),
                  const SizedBox(width: 8),
                  _callButton('Rescue', EmergencyNumbers.rescue),
                  const SizedBox(width: 8),
                  _callButton('Edhi', EmergencyNumbers.edhi),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _callButton(String label, String number) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => EmergencyNumbers.call(number),
        style: OutlinedButton.styleFrom(
          foregroundColor: _red,
          side: const BorderSide(color: _red),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
            Text(number,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'SOS. Press and hold to send an emergency alert',
      child: GestureDetector(
        onLongPressStart: (_) => _startHold(),
        onLongPressEnd: (_) => _cancelHold(),
        onLongPressCancel: _cancelHold,
        onTap: () {
          if (_sending) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press and hold SOS to send an emergency alert.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ));
        },
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _hold,
                builder: (_, __) => SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: _sending ? null : _hold.value,
                    strokeWidth: 4,
                    color: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: _red.withOpacity(0.4), blurRadius: 12),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('SOS',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
