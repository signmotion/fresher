part of '_.dart';

class FreshAllResultRunner extends ResultRunner {
  FreshAllResultRunner();

  late Iterable<FreshProject> projects;
  late Map<String, Iterable<FileWithStatus>> filesWithStatus;
  late Map<String, Iterable<PackageWithStatus>> packagesWithStatus;

  /// All rewieved files with statuses.
  String statFiles() {
    var r = '';

    r += 'Files: ${filesWithStatus.length}$newLine';
    for (final e in filesWithStatus.entries) {
      final projectKey = e.key;
      r += '$newLine${projectKey.blueBright}$newLine';
      final table = Table(
        header: ['Status'.whiteBright, 'File'.whiteBright],
        columnAlignment: [HorizontalAlign.right, HorizontalAlign.left],
      );
      // group and sort
      final sorted = List.of(e.value, growable: false)..sort();
      for (final l in sorted) {
        final s = l.file.key;
        table.add([l.status.coloredName, s]);
      }
      r += '$table';
    }

    return r;
  }

  /// All rewieved packages with statuses.
  String statPackages() {
    var r = '';

    r += 'Packages: ${packagesWithStatus.length}$newLine';
    for (final e in packagesWithStatus.entries) {
      final projectKey = e.key;
      r += '$newLine${projectKey.blueBright}$newLine';
      final table = Table(
        header: ['Status'.whiteBright, 'Package'.whiteBright],
        columnAlignment: [HorizontalAlign.right, HorizontalAlign.left],
      );
      // group and sort
      final sorted = List.of(e.value, growable: false)..sort();
      for (final l in sorted) {
        final s = '${l.package.id} ${l.package.currentYaml} '
                '${l.status == UpdatedPackageStatus.modified ? l.package.resolvable : ""}'
            .trim();
        table.add([l.status.coloredName, s]);
      }
      r += '$table';
    }

    return r;
  }

  @override
  String toString() => '${statFiles()}$newLine${statPackages()}';
}
