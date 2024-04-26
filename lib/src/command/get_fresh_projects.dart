part of '_.dart';

class GetFreshProjects
    extends ACommand<Iterable<FreshProject>, FresherOptions> {
  const GetFreshProjects(super.options);

  @override
  Future<Iterable<FreshProject>> run() async => Fresher(options).projects;
}
