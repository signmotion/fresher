part of '_.dart';

/// Push a changes from git to file.
class GitLog extends ACommand<WFile, FresherOptions> {
  const GitLog(
    super.options, {
    super.output,
    required this.pathPrefix,
    required this.project,
  });

  final String pathPrefix;
  final FreshProject project;

  static const filename = 'git.log';

  @override
  Future<WFile> run() async {
    final path =
        p.join(fresherOutputFolder, project.sdk, project.id, 'git.log').npath;
    output('Fetching a log to `$path`...');

    const executable = 'git';
    final args = [
      '-C',
      pathPrefix.isEmpty ? '.' : '$pathPrefix/${project.id}',
      'log',
      '--oneline',
    ];
    late final Process process;
    try {
      process = await Process.start(executable, args);
    } catch (ex) {
      logger.e(ex);
      rethrow;
    }

    final outputStdout =
        await process.stdout.transform(utf8.decoder).join(newLine);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      logger.i(outputStdout);
      final outputStderr =
          await process.stderr.transform(utf8.decoder).join(newLine);
      logger.e(outputStderr);
      throw Exception('Process `$executable` with `$args` failed.'
          ' Exit code is $exitCode.'
          ' Error output: `$outputStderr`.');
    }

    final file = WFile(path)..writeAsText(outputStdout);
    if (!file.existsFile()) {
      throw Exception('File `$path` is not created.');
    }

    output('Fetched a log to `$path`.');

    return file;
  }
}
