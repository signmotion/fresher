import 'package:test/test.dart';

import '../util/cli.dart';

Future<void> main() async {
  const cli = Cli();

  group('call dart.exe, fast check', () {
    test('pub get', () async {
      final process = await cli.run(['--version']);
      await expectLater(
        process.stdout,
        emits(startsWith('Dart SDK version:')),
      );
      await process.shouldExit(0);
    });
  });

  group('fresher.dart --projects=id_gen', () {
    test('--no-upgrade-dependencies', () async {
      final process = await cli.run([
        'bin/fresher.dart',
        '--no-upgrade-dependencies',
        'test/data/all_projects',
      ]);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Maintained projects:')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
      await process.shouldExit(0);
    });
  });
}
