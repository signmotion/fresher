part of '../../tools_fresher.dart';

class ToolsOptions {
  String sourcePathPrefix = '';
  String sourceFolder = '';

  String get sourcePath => p.join(sourcePathPrefix, sourceFolder);
  Directory get sourceDirectory => Directory(sourcePath);

  List<String> projectIds = [];
}
