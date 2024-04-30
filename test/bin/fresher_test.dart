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
    });
  }, tags: ['windows']);

  group('fresher.dart --projects=id_gen --no-changes --no-upgrade', () {
    test('check maintained projects', () async {
      final process = await cli.run([
        'bin/fresher.dart',
        '--projects=id_gen',
        '--no-changes',
        '--no-upgrade',
        'test/data/all_projects',
      ]);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Maintained ')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
    });
  }, tags: ['windows']);

  group('fresher.dart --projects=id_gen --no-changes', () {
    test('check upgraded dependencies', () async {
      final process = await cli.run([
        'bin/fresher.dart',
        '--projects=id_gen',
        '--no-changes',
        'test/data/all_projects',
      ]);
      await expectLater(
        process.stdout,
        emitsThrough(startsWith('Upgraded dependencies for project')),
      );
      await expectLater(process.stdout, emitsThrough('Result prepared.'));
    });
  }, tags: ['windows']);
}
