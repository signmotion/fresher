import 'package:test/test.dart';

import '../util/cli.dart';

Future<void> main() async {
  const cli = Cli();

  group('call dart.exe', () {
    test('pub get', () async {
      final process = await cli.run(['pub', 'get']);
      await expectLater(process.stdout, emits('Resolving dependencies...'));
      await expectLater(process.stdout, emitsThrough('Got dependencies!'));
      await process.shouldExit(0);
    });
  });

  group('fresher FreshAll', () {
    test('correct path', () async {
      final process = await cli.run(['pub', 'get']);
      await expectLater(process.stdout, emits('Resolving dependencies...'));
      await expectLater(process.stdout, emitsThrough('Got dependencies!'));
      await process.shouldExit(0);
    });
  }, tags: ['current']);
}
