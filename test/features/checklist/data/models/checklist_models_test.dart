import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/checklist/data/models/checklist_answer.dart';
import 'package:smartvan_driver/features/checklist/data/models/checklist_item_def.dart';
import 'package:smartvan_driver/features/checklist/data/models/today_checklist.dart';

import '../../../../support/fixture.dart';

void main() {
  final f = fixtureMap('checklist/checklist.json');
  Map<String, dynamic> body(String key) =>
      Map<String, dynamic>.from(f[key] as Map);

  test('ChecklistItemDef list', () {
    final items = asJsonList(unwrapData(f['items']))
        .map(ChecklistItemDef.fromJson)
        .toList();
    expect(items.map((i) => i.key), ['tyres', 'brakes']);
    expect(items[1].label, 'Brakes work');
  });

  group('TodayChecklist', () {
    test('submitted today with an issue', () {
      final t = TodayChecklist.fromJson(body('todayDone'));
      expect(t.required, isTrue);
      expect(t.done, isTrue);
      expect(t.allOk, isFalse);
      expect(t.checklist!.photoUrl, 'https://example.test/img/van-check.png');
      expect(t.checklist!.items, hasLength(2));
      expect(
          t.checklist!.items[0], const ChecklistAnswer(key: 'tyres', ok: true));
      expect(t.checklist!.items[1].note, 'Pedal feels soft');
    });

    test('not done yet', () {
      final t = TodayChecklist.fromJson(body('todayNotDone'));
      expect(t.done, isFalse);
      expect(t.required, isFalse);
      expect(t.allOk, isTrue); // nothing recorded = nothing wrong
      expect(t.checklist, isNull);
    });

    test('allOk missing counts as ok; strings for booleans', () {
      final t = TodayChecklist.fromJson(body('todayNoAllOk'));
      expect(t.required, isTrue); // "true"
      expect(t.checklist!.allOk, isNull);
      expect(t.allOk, isTrue);
      expect(t.checklist!.items.single.ok, isTrue); // "true"
    });

    test('empty body', () {
      final t = TodayChecklist.fromJson({});
      expect(t.done, isFalse);
      expect(t.required, isFalse);
    });
  });

  test('ChecklistAnswer sends the note only when there is one', () {
    expect(const ChecklistAnswer(key: 'tyres', ok: true).toJson(),
        {'key': 'tyres', 'ok': true});
    expect(
        const ChecklistAnswer(key: 'brakes', ok: false, note: 'Soft').toJson(),
        {'key': 'brakes', 'ok': false, 'note': 'Soft'});
  });
}
