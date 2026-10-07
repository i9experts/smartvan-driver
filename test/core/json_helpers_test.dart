import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';

void main() {
  group('unwrapData', () {
    test('{data: x}', () {
      expect(
          unwrapData({
            'data': [1, 2]
          }),
          [1, 2]);
      expect(
          unwrapData({
            'data': {'a': 1},
            'message': 'ok'
          }),
          {'a': 1});
    });

    test('{data: {data: x}}', () {
      expect(
          unwrapData({
            'data': {
              'data': [1]
            }
          }),
          [1]);
    });

    test('raw list and raw map are returned as is', () {
      expect(unwrapData([1, 2]), [1, 2]);
      expect(unwrapData({'fullname': 'Danish'}), {'fullname': 'Danish'});
    });

    test('null and {data: null}', () {
      expect(unwrapData(null), isNull);
      expect(unwrapData({'data': null}), isNull);
    });

    test('unwraps at most two levels', () {
      expect(
          unwrapData({
            'data': {
              'data': {'data': 1}
            }
          }),
          {'data': 1});
    });
  });

  group('asJsonMap / asJsonList', () {
    test('asJsonMap converts to Map<String, dynamic>', () {
      final m = asJsonMap(<dynamic, dynamic>{'a': 1});
      expect(m, isA<Map<String, dynamic>>());
      expect(() => asJsonMap([1]), throwsFormatException);
    });

    test('asJsonList treats null as empty', () {
      expect(asJsonList(null), isEmpty);
      expect(
          asJsonList([
            <String, dynamic>{'a': 1}
          ]),
          [
            {'a': 1}
          ]);
      expect(() => asJsonList({'a': 1}), throwsFormatException);
      expect(() => asJsonList([1]), throwsFormatException);
    });
  });
}
