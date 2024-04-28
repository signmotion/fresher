part of '_.dart';

class FreshProjectFiles
    extends ACommand<Iterable<FileWithStatus>, FresherOptions> {
  const FreshProjectFiles(
    super.options, {
    super.output,
    required this.pathPrefix,
    required this.project,
  });

  final String pathPrefix;
  final FreshProject project;

  @override
  Future<Iterable<FileWithStatus>> run() async {
    final fresher = Fresher(options);
    final files = fresher.projectFiles(project.sdk, project.id);
    final variables = fresher.projectVariables(project.sdk, project.id);
    final filesWithStatus = <FileWithStatus>[];
    for (final file in files) {
      final from = file.file.npath;
      final to = file.pathToFileForUpdate(pathPrefix, project.id);
      final pfrom =
          from.replaceFirst('./', '').replaceFirst('$fresherPrefix/', '');
      output('$pfrom -> $to');
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

      if (!o.noChanges) {
        const writes = [UpdatedFileStatus.added, UpdatedFileStatus.modified];
        if (writes.contains(status)) {
          fileTo.writeAsBytes(content);
        }
      }

      filesWithStatus.add(FileWithStatus(file: file, status: status));

      output('  ${status.name}');
    }

    return filesWithStatus;
  }
}
