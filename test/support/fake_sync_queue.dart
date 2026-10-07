import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';

/// One call to `SyncQueue.submit`.
class SubmitCall {
  SubmitCall(this.kind, this.path, this.body, this.tripId, this.kidId);
  final String kind;
  final String path;
  final Map<String, dynamic> body;
  final String? tripId;
  final String? kidId;
}

/// Records what repositories submit and answers with a canned outcome (or
/// throws [error], like the real queue does for a 4xx).
class FakeSyncQueue extends Mock implements SyncQueue {
  final List<SubmitCall> calls = [];
  SubmitOutcome outcome = SubmitOutcome.sent;
  Object? error;
  Map<String, String> pendingStatusMap = {};

  /// What [flush] answers (true = queue empty afterwards).
  bool flushResult = true;
  int flushes = 0;

  @override
  final ValueNotifier<int> pending = ValueNotifier<int>(0);

  @override
  Future<bool> flush() async {
    flushes++;
    return flushResult;
  }

  String? pendingQueriedFor;

  @override
  Future<SubmitOutcome> submit({
    required String kind,
    required String path,
    required Map<String, dynamic> body,
    String? tripId,
    String? kidId,
  }) async {
    calls.add(SubmitCall(kind, path, body, tripId, kidId));
    final e = error;
    if (e != null) throw e;
    return outcome;
  }

  @override
  Map<String, String> pendingKidStatuses(String? tripId) {
    pendingQueriedFor = tripId;
    return pendingStatusMap;
  }
}
