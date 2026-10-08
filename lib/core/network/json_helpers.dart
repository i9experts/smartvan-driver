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

// ---------------------------------------------------------------------------
// Model helpers (docs/ARCHITECTURE.md §5)
//
// The backend is not consistent about field names or types. Models absorb
// that here, with `@JsonKey(readValue: ...)` / `fromJson:` — never screens.
// ---------------------------------------------------------------------------

/// First non-null value among [keys] of [map].
Object? firstOf(Map<dynamic, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value != null) return value;
  }
  return null;
}

/// `map[outer][inner]` when `map[outer]` is a map, else null.
Object? nested(Map<dynamic, dynamic> map, String outer, String inner) {
  final o = map[outer];
  return o is Map ? o[inner] : null;
}

// ---- readValue functions (signature: Object? Function(Map, String)) ------

/// `_id` | `id`
Object? readId(Map<dynamic, dynamic> m, String _) => firstOf(m, ['_id', 'id']);

/// `kidId` | `_id` | `id`
Object? readKidId(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['kidId', '_id', 'id']);

/// `fullname` | `name`
Object? readFullname(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['fullname', 'name']);

/// `image` | `profileImage`
Object? readImage(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['image', 'profileImage']);

/// `lng` | `long` (location payloads use both)
Object? readLng(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['lng', 'long']);

/// `TripStarted` (PascalCase, assigned-route endpoint) | `tripStarted`
Object? readTripStarted(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['TripStarted', 'tripStarted']);

/// `TripCompleted` (PascalCase, assigned-route endpoint) | `tripCompleted`
Object? readTripCompleted(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['TripCompleted', 'tripCompleted']);

/// `tripStatus` | `status`, lower-cased.
Object? readTripStatus(Map<dynamic, dynamic> m, String _) =>
    lowerCased(firstOf(m, ['tripStatus', 'status']));

/// `type` lower-cased (trip documents; the app compared it case-insensitively).
Object? readTypeLower(Map<dynamic, dynamic> m, String _) =>
    lowerCased(m['type']);

/// `tripType` lower-cased (passenger rows carry the trip's direction).
Object? readTripTypeLower(Map<dynamic, dynamic> m, String _) =>
    lowerCased(m['tripType']);

/// `status` lower-cased (trip documents).
Object? readStatusLower(Map<dynamic, dynamic> m, String _) =>
    lowerCased(m['status']);

/// `school.schoolName` | `schoolName`
Object? readSchoolName(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'school', 'schoolName') ?? m['schoolName'];

/// `parent.phoneNo` | `parentPhone` | `phoneNo`
Object? readParentPhone(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'parent', 'phoneNo') ?? firstOf(m, ['parentPhone', 'phoneNo']);

/// `parent.alternatePhoneNo` | `alternatePhone`
Object? readParentAlternatePhone(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'parent', 'alternatePhoneNo') ?? m['alternatePhone'];

/// `parent.address` | `address`
Object? readParentAddress(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'parent', 'address') ?? m['address'];

/// `tripName` | `name` | `schoolRoute` | `route`
Object? readTripName(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['tripName', 'name', 'schoolRoute', 'route']);

/// `tripStart.startTime` | `startTime`
Object? readTripStartTime(Map<dynamic, dynamic> m, String _) =>
    nested(m, 'tripStart', 'startTime') ?? m['startTime'];

/// `licenceImageFront` | `licenseImageFront`
Object? readLicenceFront(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['licenceImageFront', 'licenseImageFront']);

/// `licenceImageBack` | `licenseImageBack`
Object? readLicenceBack(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['licenceImageBack', 'licenseImageBack']);

/// `expiryDateLicense` | `expiryDateLicence`
Object? readLicenceExpiry(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['expiryDateLicense', 'expiryDateLicence']);

/// `alertType` | `type`, lower-cased.
Object? readAlertType(Map<dynamic, dynamic> m, String _) =>
    lowerCased(firstOf(m, ['alertType', 'type']));

/// `message` | `description` | `body`
Object? readAlertMessage(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['message', 'description', 'body']);

/// `createdAt` | `date`
Object? readAlertDate(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['createdAt', 'date']);

// ---- converters (use as `fromJson:` on a field) --------------------------

/// Lower-cased string, or the value unchanged when it is not a string.
Object? lowerCased(Object? value) =>
    value is String ? value.trim().toLowerCase() : value;

/// `5`, `5.0` and `"5"` all become 5; anything else is null.
int? looseInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value.trim()) ?? double.tryParse(value.trim())?.toInt();
  }
  return null;
}

/// `5`, `5.5` and `"5.5"` all become a double; anything else is null.
double? looseDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}

/// `true`, `"true"`, `1` are true; everything else (incl. null) is false.
bool looseBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.trim().toLowerCase();
    return v == 'true' || v == '1';
  }
  return false;
}

/// Any scalar as a trimmed string; null for null / empty / maps / lists.
String? looseString(Object? value) {
  if (value == null || value is Map || value is List) return null;
  final s = value.toString().trim();
  return s.isEmpty ? null : s;
}

/// Same as [looseString] but never null.
String looseStringOrEmpty(Object? value) => looseString(value) ?? '';

/// ISO-8601 → [DateTime]; null if missing or unparsable.
DateTime? looseDateTime(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

/// Calendar date in `YYYY-MM-DD`, full ISO-8601 or `DD/MM/YYYY` (`-` also
/// accepted) — the formats driver document expiry dates arrive in.
DateTime? looseDate(Object? value) {
  if (value is! String) return null;
  final v = value.trim();
  if (v.isEmpty) return null;
  final dmy = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(v);
  if (dmy != null) {
    return DateTime(int.parse(dmy.group(3)!), int.parse(dmy.group(2)!),
        int.parse(dmy.group(1)!));
  }
  return DateTime.tryParse(v);
}

/// ISO-8601 → local [DateTime]; null if missing or unparsable.
DateTime? looseLocalDateTime(Object? value) => looseDateTime(value)?.toLocal();
