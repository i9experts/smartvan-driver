import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../passengers/data/models/kid_absence_event.dart';

/// Where the tracking socket drops "a parent marked a kid absent / cancelled
/// it" events.
final kidAbsenceBusProvider =
    Provider<StreamController<KidAbsenceEvent>>((ref) {
  final controller = StreamController<KidAbsenceEvent>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

/// Absence events during the trip, for the screens that react to them.
final kidAbsenceEventsProvider = StreamProvider.autoDispose<KidAbsenceEvent>(
  (ref) => ref.watch(kidAbsenceBusProvider).stream,
);
