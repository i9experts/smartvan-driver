/// Unwraps the backend's response envelope. Handles every shape in use:
///
/// * `{data: x}`
/// * `{data: {data: x}}`
/// * a raw list or a raw map (no envelope) — returned as is
///
/// Screens and repositories must not unwrap by hand; they call this (via
/// `ApiClient`) and then parse the result.
Object? unwrapData(Object? json) {
  var value = json;
  for (var i = 0; i < 2; i++) {
    if (value is Map && value.containsKey('data')) {
      value = value['data'];
    } else {
      break;
    }
  }
  return value;
}

/// [json] as a `Map<String, dynamic>`; throws a [FormatException] otherwise.
Map<String, dynamic> asJsonMap(Object? json) {
  if (json is Map) return Map<String, dynamic>.from(json);
  throw FormatException('Expected a JSON object, got ${json.runtimeType}');
}

/// [json] as a list of objects; `null` is an empty list, anything else that
/// is not a list throws a [FormatException].
List<Map<String, dynamic>> asJsonList(Object? json) {
  if (json == null) return const [];
  if (json is List) return json.map(asJsonMap).toList();
  throw FormatException('Expected a JSON array, got ${json.runtimeType}');
}
