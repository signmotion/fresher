import 'dart:io';

import 'package:fresher/fresher.dart';
import 'package:fresher/src/command/_.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

Future<void> main() async {
  group('correct data', () {
    final source = p.join('test', 'data', 'all_projects');
    final options = FresherOptions()..sourceDirectory = Directory(source);
    const project = FreshProject(sdk: 'dart', id: 'id_gen');
    final command = FreshProjectFiles(
      options,
      pathPrefix: '_output',
      project: project,
    );

    test('run', () async {
      final r = await command.run();
      expect(r.length, greaterThanOrEqualTo(18));
    });
  });
}
