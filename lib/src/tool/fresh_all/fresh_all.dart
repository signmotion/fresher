part of '_.dart';

class FreshAll extends Runner<FreshAllResultRunner> {
  FreshAll(this.options) {
    assert(
      o.sourceDirectory != null && o.sourceDirectory!.existsSync(),
      'A source path `${o.sourcePath}` should be exists.',
    );
  }

  @override
  String get name => 'Fresh All';

  /// See [o].
  final FresherOptions options;

  /// Alias for [options].
  FresherOptions get o => options;

  /// Reads and constructs files from [sourcePath] and copies its to
  /// the projects folders.
  @override
  Future<FreshAllResultRunner> run() async {
    final result = FreshAllResultRunner();

    // 1) Receiving all maintained projects.
    firstStep();
    {
      printis('Receiving all maintained projects');

      result.projects = await GetFreshProjects(options).run();

      final all = result.projects.map((p) => '$p').toList();
      pr('Maintained projects: $all');
    }

    // 2) For each maintained projects.
    nextStep();
    {
      for (final project in result.projects) {
        if (o.filter.isEmpty || o.filter.contains(project.id)) {
          await _freshProject(project, result);
        } else {
          printi('\nProject `${project.id}` skipped by filter.');
          result.packagesWithStatus = const {};
        }
      }
    }

    nextStep();
    // 3) Preparing results.
    {
      printis('Preparing results');
      result.error = null;
      printi('Result prepared');
    }

    return result;
  }

  Future<void> _freshProject(
    FreshProject project,
    FreshAllResultRunner result,
  ) async {
    await _freshProjectFiles(project, result);

    if (!o.noUpgradeDependencies) {
      await _upgradeProject(project, result);
    } else {
      pr('\nSkipped an upgrade dependencies,'
          ' because `--no-upgrade`.');
    }
  }

  Future<void> _freshProjectFiles(
    FreshProject project,
    FreshAllResultRunner result,
  ) async {
    pr('\nFreshing the files for project `$project`...');
    increaseCurrentIndent();

    result.filesWithStatus = await FreshProjectFiles(
      options,
      pathPrefix: '..',
      project: project,
    ).run();

    decreaseCurrentIndent();
    pr('Freshed the files for project `$project`.');
  }

  Future<void> _upgradeProject(
    FreshProject project,
    FreshAllResultRunner result,
  ) async {
    pr('\nUpgrading dependencies for project `$project`...');
    increaseCurrentIndent();

    result.packagesWithStatus = await UpgradeProject(
      options,
      pathPrefix: '..',
      project: project,
    ).run();

    decreaseCurrentIndent();
    pr('Upgraded dependencies for project `$project`.');
  }
}
