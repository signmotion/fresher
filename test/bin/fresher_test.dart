import 'package:test/test.dart';

import '../util/cli.dart';

/// ! See BLoC tests in `test/fresh_all_test.dart`.
Future<void> main() async {
  const cli = Cli();

  group('call dart.exe, fast check', () {
    test('pub get', () async {
      final process = await cli.run(['--version']);
      await expectLater(
        process.stdout,
        emits(startsWith('Dart SDK version:')),
      );
    });
  });

  group('fresher.dart --projects=id_gen --no-upgrade', () {
    test('--no-upgrade', () async {
      final process = await cli.run([
        'bin/fresher.dart',
        '--projects=id_gen',
        '--no-upgrade',
        'test/data/all_projects',
      ]);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Maintained projects:')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
    });
  });

  group('fresher.dart --projects=id_gen', () {
    test('upgrade dependencies', () async {
      final process = await cli.run([
        'bin/fresher.dart',
        '--projects=id_gen',
        'test/data/all_projects',
      ]);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Upgraded dependencies for project')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
    });
  });
}
