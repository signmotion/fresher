part of '_.dart';

class GetSdks extends ACommand<Iterable<String>, FresherOptions> {
  const GetSdks(super.options);

  @override
  Future<Iterable<String>> run() async => Fresher(options).sdks;
}
