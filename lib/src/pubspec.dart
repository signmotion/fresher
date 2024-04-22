part of '../fresher.dart';

/// A `pubspec.yaml` file.
class Pubspec extends Equatable implements Comparable<Pubspec> {
  const Pubspec(this.pathToProject);
  // {
  //   if (!existsYaml) {
  //     throw PathNotFoundException(pathToFileYaml, const OSError());
  //   }
  // }

  static const filenameYaml = 'pubspec.yaml';
  static const filenameLock = 'pubspec.lock';

  /// A path to project folder that contains [filenameYaml].
  final String pathToProject;

  /// A path to `pubspec.yaml` file for [projectId].
  String get pathToFileYaml => p.join(pathToProject, filenameYaml).npath;

  /// A path to `pubspec.lock` file for [projectId].
  String get pathToFileLock => p.join(pathToProject, filenameLock).npath;

  WFile get fileYaml => WFile(pathToFileYaml);

  WFile get fileLock => WFile(pathToFileLock);

  bool get existsYaml => fileYaml.existsFile();

  bool get existsLock => fileLock.existsFile();

  String get rawContentYaml => fileYaml.readAsText()!;

  String get rawContentLock => fileLock.readAsText()!;

  YamlMap get contentYaml => loadYaml(rawContentYaml) as YamlMap;

  YamlMap get contentLock => loadYaml(rawContentLock) as YamlMap;

  /// Update a content for [fileYaml] to [newContent].
  void writeYaml(String newContent) => fileYaml.writeAsText(newContent);

  /// Deletes a [pathToFileLock].
  void removeLock() => fileLock.delete();

  @override
  List<Object?> get props => [pathToProject];

  /// ! Compare by [pathToFileYaml].
  @override
  int compareTo(Pubspec other) =>
      pathToFileYaml.compareTo(other.pathToFileYaml);

  @override
  String toString() => pathToFileYaml;
}
