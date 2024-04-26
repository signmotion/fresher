part of '_.dart';

class FreshAllResultRunner extends ResultRunner {
  FreshAllResultRunner()
      : projects = [],
        filesWithStatus = {},
        packagesWithStatus = {},
        gitLogs = {};

  Iterable<FreshProject> projects;
  Map<String, Iterable<FileWithStatus>> filesWithStatus;
  Map<String, Iterable<PackageWithStatus>> packagesWithStatus;
  Map<String, WFile> gitLogs;

  /// All rewieved projects.
  String statProjects() {
    var r = '';

    for (final project in projects) {
      final key = project.key;

      // files
      final files = filesWithStatus[key];
      if (files != null && files.isNotEmpty) {
        r += '$newLine${key.blueBright}$newLine';
        final table = Table(
          header: const ['Status', 'File'].map((s) => s.whiteBright).toList(),
          columnAlignment: const [HorizontalAlign.right, HorizontalAlign.left],
        );
        // group and sort
        final sorted = List.of(files, growable: false)..sort();
        for (final l in sorted) {
          final s = l.file.key;
          table.add([l.status.coloredName, s]);
        }
        r += '$table$newLine';
      }

      // upgraded packages
      final packages = packagesWithStatus[key];
      if (packages != null && packages.isNotEmpty) {
        final table = Table(
          header: const [
            'Status',
            'Package',
            'version',
            'upgraded',
          ].map((s) => s.whiteBright).toList(),
          columnAlignment: const [
            HorizontalAlign.right,
            HorizontalAlign.left,
            HorizontalAlign.right,
            HorizontalAlign.right,
          ],
        );
        // group and sort
        final sorted = List.of(packages, growable: false)..sort();
        for (final l in sorted) {
          final resolvable = l.status == UpdatedPackageStatus.modified
              ? l.package.resolvable
              : '';
          table.add([
            l.status.coloredName,
            l.package.id,
            l.package.currentYaml,
            resolvable,
          ]);
        }
        r += '$table$newLine';
      }

      // git log
      final log = gitLogs[key];
      if (log != null) {
        r += '${newLine}git log$newLine';
        var count = 0;
        final lines = log.readAsTextLines()!;
        var firstCommit = true;
        for (final line in lines) {
          final s = line.split(' ').sublist(1).join(' ').trim();
          if (s.isEmpty) {
            // skip empty line
            continue;
          }

          r += '* $s$newLine';

          ++count;
          if (count >= fresherMaxGitLogLines) {
            firstCommit = false;
            break;
          }
        }

        if (!firstCommit) {
          r += '* ...$newLine';
        }
      }
    }

    return r;
  }

  @override
  String toString() => statProjects();
}
