part of '../../tools_fresher.dart';

class Tools {
  Tools(this.options) {
    assert(options.sourceFolder.isNotEmpty);
    assert(options.sourceDirectory.existsSync(),
        'A source `${options.sourceDirectory.path}` should be exists.');
  }

  final ToolsOptions options;

  ToolsOptions get o => options;

  /// Update all projects
  Future<ResultRunner> freshAll() async =>
      FreshAll(sourceDirectory: o.sourceDirectory).run();
}
