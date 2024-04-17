import 'package:test/test.dart';

import '../util/cli.dart';

Future<void> main() async {
  const cli = Cli();

  group('call dart.exe', () {
    test('pub get', () async {
      final process = await cli.run(['--version']);
      await expectLater(
        process.stdout,
        emits(startsWith('Dart SDK version:')),
      );
      await process.shouldExit(0);
    });
  });

  group('fresher FreshAll', () {
    test('correct path', () async {
      final process =
          await cli.run(['bin/fresher.dart', 'test/data/all_projects']);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Maintained projects:')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
      await process.shouldExit(0);
    });
  });
}
