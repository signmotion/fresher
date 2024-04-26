import 'dart:io';

import 'package:fresher/fresher.dart';
import 'package:fresher/src/command/_.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:wfile/wfile.dart';

Future<void> main() async {
  group('correct data', () {
    final source = p.join('test', 'data');
    final options = FresherOptions()
      ..sourceDirectory = Directory(source)
      ..leaveSpaces = false;
    const project = FreshProject(sdk: '', id: 'pubspec_yaml_only');
    final command = UpgradeProject(
      options,
      pathPrefix: source.npath,
      project: project,
    );

    test('run', () async {
      final r = await command.run();
      expect(r.keys.toList(), const [':pubspec_yaml_only']);
      expect(r.values.first.length, 4);
    });
  }, tags: ['current']);
}
