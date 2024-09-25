import 'package:fresher/fresher.dart';
import 'package:json_dart/json_dart.dart';
import 'package:test/test.dart';
import 'package:wfile/wfile.dart';

Future<void> main() async {
  const project = FreshProject(sdk: '', id: 'pubspec_yaml_only');
  final pubspec =
      FreshPubspec.withPrefix(prefix: 'test/data', project: project);
  final pubspecYamlOnly = WFile('${pubspec.prefix}/${project.id}');

  void copyFromOriginalYaml() =>
      pubspecYamlOnly.copy('pubspec.original.yaml', 'pubspec.yaml');

  group('correct data, outdatedAsJson', () {
    test('pubspec.yaml, no pubspec.lock', () async {
      copyFromOriginalYaml();
      pubspec.removeLock();
      final r = await pubspec.outdatedAsJson;
      expect(r.length, 4, reason: r.sjson);
    });
  });

  group('correct data, outdated', () {
    test('pubspec.yaml, no pubspec.lock', () async {
      copyFromOriginalYaml();
      pubspec.removeLock();
      final r = await pubspec.outdated;
      expect(r.length, 4, reason: r.sjson);
    });
  });

  group('correct data, upgrade', () {
    test('pubspec.yaml, no pubspec.lock', () async {
      copyFromOriginalYaml();
      pubspec.removeLock();
      final content = pubspec.rawContentYaml;
      expect(content, contains('meta: ">=1.10.0 <3.0.0"'));
      expect(content, contains('uuid: ^4.1.0'));
      expect(content, contains('lints: ^3.0.0'));
      expect(content, contains('test: ^1.25.2'));

      final (newContent, upgraded, skipped) = await pubspec.upgraded;
      expect(newContent, isNot(equals(content)));
      expect(upgraded.length, 3, reason: upgraded.sjson);
      expect(skipped.length, 1, reason: skipped.sjson);
    });
  });
}
