import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/application/kid_absence_events.dart';
import '../../application/passengers_controller.dart';
import '../../application/passengers_state.dart';
import '../../data/models/passenger.dart';
import '../widgets/no_show_dialog.dart';
import '../widgets/passenger_card.dart';
import '../widgets/passengers_header.dart';

/// The kids of trip [tripId]: pick up, drop off, message the parent, tell the
/// parent the van is at the stop.
class PassengersScreen extends ConsumerStatefulWidget {
  const PassengersScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends ConsumerState<PassengersScreen> {
  static const _navy = Color(0xFF1B2B6B);

  /// Refreshes the "waiting 1:23" timers on the cards.
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = ref.read(passengersControllerProvider(widget.tripId)).valueOrNull;
      if (mounted && (s?.passengers.any((p) => p.waitingSince != null) ?? false)) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  PassengersController get _controller =>
      ref.read(passengersControllerProvider(widget.tripId).notifier);

  Future<void> _pick(Passenger kid) async {
    final l10n = context.l10n;
    if (kid.absent &&
        !await confirmPickUpAbsent(context, kid.fullname.isEmpty ? null : kid.fullname)) {
      return;
    }
    if (!mounted) return;
    final name = kid.fullname.isEmpty ? 'Kid' : kid.fullname;
    try {
      final outcome = await _controller.pick(kid);
      if (!mounted) return;
      if (outcome == StopActionOutcome.sent) {
        AppSnack.success(context, l10n.passengersPickedOk(name));
      } else {
        AppSnack.warning(context, l10n.passengersPickedOffline(name));
      }
    } catch (e) {
      if (mounted) {
        AppSnack.error(context, errorText(l10n, e, fallback: l10n.passengersPickFailed));
      }
    }
  }

  Future<void> _drop(Passenger kid) async {
    final l10n = context.l10n;
    final name = kid.fullname.isEmpty ? 'Kid' : kid.fullname;
    try {
      final outcome = await _controller.drop(kid);
      if (!mounted) return;
      switch (outcome) {
        case StopActionOutcome.noGps:
          AppSnack.error(context, l10n.passengersNoGps);
        case StopActionOutcome.sent:
          AppSnack.show(context, l10n.passengersDroppedOk(name), _navy);
        case StopActionOutcome.queued:
          AppSnack.warning(context, l10n.passengersDroppedOffline(name));
      }
    } catch (e) {
      if (mounted) {
        AppSnack.error(
            context,
            errorText(l10n, e,
                fallback: l10n.passengersDropFailed(kid.fullname.isEmpty ? 'kid' : kid.fullname)));
      }
    }
  }

  Future<void> _arrived(Passenger kid) async {
    final l10n = context.l10n;
    try {
      await _controller.arrivedAtStop(kid);
      if (mounted) AppSnack.success(context, l10n.passengersParentTold);
    } catch (e) {
      if (mounted) {
        AppSnack.error(context, errorText(l10n, e, fallback: l10n.passengersTellFailed));
      }
    }
  }

  Future<void> _noShow(Passenger kid) async {
    final l10n = context.l10n;
    final note = await showNoShowDialog(
        context, kid.fullname.isEmpty ? l10n.passengersStudentFallback : kid.fullname);
    if (note == null || !mounted) return;
    try {
      await _controller.markNoShow(kid, note: note);
    } catch (e) {
      if (mounted) {
        AppSnack.error(context, errorText(l10n, e, fallback: l10n.passengersNoShowFailed));
      }
    }
  }

  Future<void> _messageParent(Passenger kid) async {
    final l10n = context.l10n;
    try {
      final conversation = await _controller.messageParent(kid);
      if (mounted) {
        await context.push(AppRoutes.chatOf(conversation.id), extra: conversation);
      }
    } catch (e) {
      if (mounted) {
        AppSnack.error(context, errorText(l10n, e, fallback: l10n.passengersChatFailed));
      }
    }
  }

  Future<void> _openScanner() async {
    await context.push(AppRoutes.scan);
    if (mounted) _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(passengersControllerProvider(widget.tripId));

    // A parent marked a child absent (or cancelled it) during the trip.
    ref.listen(kidAbsenceEventsProvider, (_, next) {
      final e = next.valueOrNull;
      if (e == null) return;
      final name = e.fullname.isEmpty ? l10n.passengersAStudent : e.fullname;
      AppSnack.show(
        context,
        e.cancelled ? l10n.passengersRidesAfterAll(name) : l10n.passengersAbsentEvent(name),
        _navy,
      );
    });

    final state = async.valueOrNull;
    final Widget body;
    if (state != null) {
      body = state.passengers.isEmpty
          ? const _EmptyPassengers()
          : RefreshIndicator(
              onRefresh: () => _controller.refresh(),
              color: _navy,
              child: _PassengerList(
                state: state,
                now: ref.read(clockProvider)(),
                onOpenProfile: (k) => context.push(AppRoutes.kidOf(k.id), extra: k),
                onMessage: _messageParent,
                onPick: _pick,
                onDrop: _drop,
                onArrived: _arrived,
                onNoShow: _noShow,
              ),
            );
    } else if (async.hasError) {
      body = LoadErrorView(
        title: l10n.passengersErrorTitle,
        message: l10n.passengersErrorBody,
        retryLabel: l10n.commonRetry,
        onRetry: () => ref.invalidate(passengersControllerProvider(widget.tripId)),
      );
    } else {
      body = const AppLoading();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          PassengersHeader(
            total: state?.total ?? 0,
            picked: state?.pickedCount ?? 0,
            onBack: () => context.popOrGoTrip(widget.tripId),
            onScan: _openScanner,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

extension on BuildContext {
  void popOrGoTrip(String tripId) {
    if (canPop()) {
      pop();
    } else {
      go(AppRoutes.tripOf(tripId));
    }
  }
}

class _PassengerList extends StatelessWidget {
  const _PassengerList({
    required this.state,
    required this.now,
    required this.onOpenProfile,
    required this.onMessage,
    required this.onPick,
    required this.onDrop,
    required this.onArrived,
    required this.onNoShow,
  });

  final PassengersState state;
  final DateTime now;
  final void Function(Passenger) onOpenProfile;
  final void Function(Passenger) onMessage;
  final void Function(Passenger) onPick;
  final void Function(Passenger) onDrop;
  final void Function(Passenger) onArrived;
  final void Function(Passenger) onNoShow;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.passengers.length,
      itemBuilder: (context, index) {
        final kid = state.passengers[index];
        return PassengerCard(
          passenger: kid,
          status: state.statusOf(kid),
          unsynced: state.isUnsynced(kid),
          stopBusy: state.stopBusy.contains(kid.id),
          now: now,
          onOpenProfile: () => onOpenProfile(kid),
          onMessage: () => onMessage(kid),
          onPick: () => onPick(kid),
          onDrop: () => onDrop(kid),
          onArrived: () => onArrived(kid),
          onNoShow: () => onNoShow(kid),
        );
      },
    );
  }
}

class _EmptyPassengers extends StatelessWidget {
  const _EmptyPassengers();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B6B).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline, size: 40, color: Color(0xFF1B2B6B)),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.passengersEmptyTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.passengersEmptyBody,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
