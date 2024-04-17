// ignore_for_file: avoid_print

import 'dart:async';

import 'package:test_process/test_process.dart';

class Cli {
  const Cli();

  /// Runs the CLI's entrypoint and verifies that it exits with
  /// exit code 0.
  Future<TestProcess> run(
    List<String> args, {
    Map<String, String>? environment,
  }) async {
    final process =
        await TestProcess.start('dart', args, environment: environment);

    if (await process.exitCode != 0) {
      process.stdoutStream().listen(print);
      process.stderrStream().listen(print);
    }
    await process.shouldExit(0);

    return process;
  }
}
