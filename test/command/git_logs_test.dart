import 'dart:io';

import 'package:fresher/fresher.dart';
import 'package:fresher/src/command/_.dart';
import 'package:test/test.dart';
import 'package:wfile/wfile.dart';

Future<void> main() async {
  group('correct data', () {
    // from root folder
    const source = '';
    final options = FresherOptions()..sourceDirectory = Directory(source);
    const project = FreshProject(sdk: '', id: 'fresher');
    final command = GitLog(
      options,
      pathPrefix: source.npath,
      project: project,
    );

    test('run', () async {
      WFile(fresherOutputFolder).delete();
      final r = await command.run();
      expect(r.npath, '$fresherOutputFolder/fresher/git.log');
      expect(r.existsFile(), isTrue);
      expect(r.readAsText(), isNotEmpty);
    });
  });
}
