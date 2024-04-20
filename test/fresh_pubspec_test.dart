import 'package:fresher/fresher.dart';
import 'package:json_dart/json_dart.dart';
import 'package:test/test.dart';

void main() {
  group('correct data, outdatedAsJson', () {
    test('pubspec.yaml, no pubspec.lock', () async {
      final pubspec = FreshPubspec('test/data/pubspec_yaml_only');
      final r = await pubspec.outdatedAsJson;
      expect(r.length, 4, reason: r.sjson);
    });

    test('pubspec.lock + pubspec.yaml', () async {
      final pubspec = FreshPubspec('test/data/pubspec_lock_and_yaml');
      final r = await pubspec.outdatedAsJson;
      expect(r.length, 0, reason: r.sjson);
    });
  });

  group('correct data, outdated', () {
    test('pubspec.yaml, no pubspec.lock', () async {
      final pubspec = FreshPubspec('test/data/pubspec_yaml_only');
      final r = await pubspec.outdated;
      expect(r.length, 4, reason: r.sjson);
    });

    test('pubspec.lock + pubspec.yaml', () async {
      final pubspec = FreshPubspec('test/data/pubspec_lock_and_yaml');
      final r = await pubspec.outdated;
      expect(r.length, 0, reason: r.sjson);
    });
  });
}
