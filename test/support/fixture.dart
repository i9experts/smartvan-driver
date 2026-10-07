import 'dart:convert';
import 'dart:io';

/// Reads `test/fixtures/<name>` and decodes it. Fixtures are made-up data
/// (fake names, phones, ids) in the shapes the backend really sends.
Object? fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync());

Map<String, dynamic> fixtureMap(String name) =>
    Map<String, dynamic>.from(fixture(name)! as Map);

List<Map<String, dynamic>> fixtureList(String name) => (fixture(name)! as List)
    .map((e) => Map<String, dynamic>.from(e as Map))
    .toList();
