part of 'bloc.dart';

class FreshAllResultRunner extends ResultRunner {
  const FreshAllResultRunner({
    required super.ok,
    super.error,
    required this.state,
  });

  final FreshAllState state;

  /// All rewieved files with statuses.
  String statFiles() {
    var r = '';

    r += 'Files: ${state.filesWithStatus.length}$newLine';
    for (final e in state.filesWithStatus.entries) {
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

    r += 'Packages: ${state.packagesWithStatus.length}$newLine';
    for (final e in state.packagesWithStatus.entries) {
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
