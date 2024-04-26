part of '../../tool_fresher.dart';

class Tool {
  Tool(this.options) {
    assert(options.sourceFolder.isNotEmpty);
    assert(options.sourceDirectory.existsSync(),
        'A source `${options.sourceDirectory.path}` should be exists.');
  }

  /// See [o].
  final ToolOptions options;

  /// Alias for [options].
  ToolOptions get o => options;

  /// Update all projects
  Future<FreshAllResultRunner> freshAll() async => FreshAll(FresherOptions()
        ..sourceDirectory = o.sourceDirectory
        ..filter = o.projectIds
        ..leaveSpaces = o.leaveSpaces
        ..noUpgradeDependencies = o.noUpgrade)
      .run();
}
