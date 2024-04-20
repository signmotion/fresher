part of '../../tools_fresher.dart';

class Tools {
  Tools(this.options) {
    assert(options.sourceFolder.isNotEmpty);
    assert(options.sourceDirectory.existsSync(),
        'A source `${options.sourceDirectory.path}` should be exists.');
  }

  /// See [o].
  final ToolsOptions options;

  /// Alias for [options].
  ToolsOptions get o => options;

  /// Update all projects
  Future<ResultRunner> freshAll() async => FreshAll(FresherOptions()
        ..sourceDirectory = o.sourceDirectory
        ..filter = o.projectIds
        ..leaveSpaces = o.leaveSpaces)
      .run();
}
