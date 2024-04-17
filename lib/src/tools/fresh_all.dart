part of '../../tools_fresher.dart';

class FreshAll extends Runner {
  FreshAll({required this.sourceDirectory}) {
    assert(
      sourceDirectory.existsSync(),
      'A source path `$sourcePath` should be exists.',
    );
  }

  final Directory sourceDirectory;
  String get sourcePath => sourceDirectory.path;

  @override
  String get name => 'Fresh All';

  /// Reads and constructs files from [sourcePath] and copies its to
  /// the projects folders.
  @override
  Future<ResultRunner> run() async {
    final bloc = FreshAllBloc(sourceDirectory);

    // 1) Receiving all maintained projects.
    firstStep();
    {
      printis('Receiving all maintained projects from `$sourcePath`');

      bloc.add(const GettingFreshProjectsEvent());
      await bloc.completed;

      final all = bloc.state.projects.map((p) => '$p').toList();
      pr('Maintained projects: $all');
    }

    // 2) For each maintained projects.
    nextStep();
    {
      for (final project in bloc.state.projects) {
        await _freshProject(project, bloc);
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
    printis('Freshing the project `$project`');
    increaseCurrentIndent();

    bloc.add(FreshingProjectEvent(project: project));
    await bloc.completed;

    for (final fs in bloc.state.filesWithStatus) {
      printi('$fs', finalizer: false);
    }

    decreaseCurrentIndent();
    printi('Freshed the project `$project`');
  }
}
