part of '../../tool_fresher.dart';

class ToolOptions {
  String sourcePathPrefix = '';
  String sourceFolder = '';

  String get sourcePath => p.join(sourcePathPrefix, sourceFolder);
  Directory get sourceDirectory => Directory(sourcePath);

  List<String> projectIds = [];

  bool leaveSpaces = false;
  bool noUpgrade = false;
}
