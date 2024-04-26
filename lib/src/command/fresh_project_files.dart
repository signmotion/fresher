part of '_.dart';

class FreshProjectFiles
    extends ACommand<Map<String, Iterable<FileWithStatus>>, FresherOptions> {
  const FreshProjectFiles(
    super.options, {
    required this.pathPrefix,
    required this.project,
    this.output = defaultOutput,
  });

  final String pathPrefix;
  final FreshProject project;
  final void Function(String s) output;

  // ignore: avoid_print
  static void defaultOutput(String s) => print(s);

  /// Key is [FreshProject.key].
  @override
  Future<Map<String, Iterable<FileWithStatus>>> run() async {
    final fresher = Fresher(options);
    final files = fresher.projectFiles(project.sdk, project.id);
    final variables = fresher.projectVariables(project.sdk, project.id);
    final filesWithStatus = <String, Iterable<FileWithStatus>>{};
    for (final file in files) {
      final from = file.file.npath;
      final to = file.pathToFileForUpdate(pathPrefix, project.id);
      output('$from\n  -> $to');
      if (file.fileConflictResolution != FileConflictResolution.overwrite) {
        output(
            '  with conflict resolution ${file.fileConflictResolution.name}');
      }

      final fileTo = WFile(to);
      final prevContent = fileTo.readAsBytes();
      final content =
          file.binary ? file.rawValueAsBytes : file.valueAsBytes(variables);

      late final UpdatedFileStatus status;
      if (prevContent == null) {
        status = UpdatedFileStatus.added;
      } else if (file.fileConflictResolution ==
          FileConflictResolution.doNotOverwrite) {
        status = UpdatedFileStatus.skipped;
      } else if (content.toList().equals(prevContent.toList())) {
        status = UpdatedFileStatus.unchanged;
      } else {
        status = UpdatedFileStatus.modified;
      }

      const writes = [UpdatedFileStatus.added, UpdatedFileStatus.modified];
      if (writes.contains(status)) {
        fileTo.writeAsBytes(content);
      }

      filesWithStatus.update(
        project.key,
        (prev) => [...prev, FileWithStatus(file: file, status: status)],
        ifAbsent: () => [FileWithStatus(file: file, status: status)],
      );

      output('  ${status.name}');
    }

    return filesWithStatus;
  }
}
