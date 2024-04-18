part of 'bloc.dart';

class FreshAll extends Runner {
  FreshAll({
    required this.sourceDirectory,
    this.filter = const [],
  }) {
    assert(
      sourceDirectory.existsSync(),
      'A source path `$sourcePath` should be exists.',
    );
  }

  @override
  String get name => 'Fresh All';

  final Directory sourceDirectory;
  String get sourcePath => sourceDirectory.path;

  /// Project IDs to update.
  /// If empty, then will update all projects.
  final List<String> filter;

  /// Reads and constructs files from [sourcePath] and copies its to
  /// the projects folders.
  @override
  Future<ResultRunner> run() async {
    final bloc = FreshAllBloc(sourceDirectory);

    // 1) Receiving all maintained projects.
    firstStep();
    {
      printis('Receiving all maintained projects');

      const event = GettingFreshProjectsEvent();
      bloc.add(event);
      await bloc.completed('$event');

      final all = bloc.state.projects.map((p) => '$p').toList();
      pr('Maintained projects: $all');
    }

    // 2) For each maintained projects.
    nextStep();
    {
      for (final project in bloc.state.projects) {
        if (filter.isEmpty || filter.contains(project.id)) {
          await _freshProject(project, bloc);
        } else {
          printi('\nProject `${project.id}` skipped by filter.');
        }
      }
    }

    nextStep();
    late final FreshAllResultRunner r;
    // 3) Preparing results.
    {
      printis('Preparing results');
      r = FreshAllResultRunner(ok: true, state: bloc.state);
      printi('Result prepared');
    }

    return r;
  }

  Future<void> _freshProject(
    FreshProject project,
    FreshAllBloc bloc,
  ) async {
    pr('\nFreshing the project `$project`...');
    increaseCurrentIndent();

    bloc.add(FreshingProjectEvent(project: project));
    await bloc.completed(project.id);

    decreaseCurrentIndent();
    pr('Freshed the project `$project`.');
  }
}
