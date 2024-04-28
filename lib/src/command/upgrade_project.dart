part of '_.dart';

class UpgradeProject
    extends ACommand<Iterable<PackageWithStatus>, FresherOptions> {
  const UpgradeProject(
    super.options, {
    super.output,
    required this.pathPrefix,
    required this.project,
  });

  final String pathPrefix;
  final FreshProject project;

  /// Key is [FreshProject.key].
  @override
  Future<Iterable<PackageWithStatus>> run() async {
    final pubspec = FreshPubspec.withPrefix(
      prefix: pathPrefix,
      project: project,
    );
    output('Looking `pubspec.yaml` by path `${pubspec.pathToProject}`...');
    if (!pubspec.existsYaml) {
      logger.e('File `${pubspec.pathToFileYaml}` not found.');
      throw PathNotFoundException(pubspec.pathToFileYaml, const OSError());
    }

    if (pubspec.existsLock) {
      output('Removing `${pubspec.pathToFileLock}`...');
      pubspec.removeLock();
      output('Removed `${pubspec.pathToFileLock}`.');
    }

    // final outdated = await pubspec.outdated;
    // for (final package in outdated.values) {
    //   print('$package');
    // }

    output('Upgrading `${pubspec.pathToFileYaml}`...');
    final (newContent, upgradedPackages, skippedPackages) =
        await pubspec.upgraded;
    if (!o.noChanges) {
      pubspec.writeYaml(newContent);
    }
    final countPackages = upgradedPackages.length + skippedPackages.length;
    output('Upgraded ${upgradedPackages.length}/$countPackages packages'
        ' into `${pubspec.pathToFileYaml}`.');

    final upgradedPackagesWithStatus =
        upgradedPackages.map((package) => PackageWithStatus(
              package: package,
              status: UpdatedPackageStatus.modified,
            ));
    final skippedPackagesWithStatus =
        skippedPackages.map((package) => PackageWithStatus(
              package: package,
              status: UpdatedPackageStatus.unchanged,
            ));
    final packagesWithStatus = <PackageWithStatus>[
      ...upgradedPackagesWithStatus,
      ...skippedPackagesWithStatus,
    ];

    // final pubspec = Pubspec('../${project.id}');
    // final d = pubspec.content;
    // final dependencies = {
    //   ...d['dependencies'] as YamlMap,
    //   ...d['dev_dependencies'] as YamlMap,
    // };
    // for (final e in dependencies.entries) {
    //   print(e);
    //   final package = FreshPackage(
    //     id: e.key as String,
    //     currentYaml: e.value as String,
    //   );
    //   final latestVersion = await package.getLatestVersion;
    //   print('$package, latest version `$latestVersion`');
    // }

    output('Upgraded `pubspec.yaml` by path `${pubspec.pathToProject}`.');

    return packagesWithStatus;
  }
}
