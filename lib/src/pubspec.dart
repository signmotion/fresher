part of '../fresher.dart';

/// A `pubspec.yaml` file.
class Pubspec extends Equatable implements Comparable<Pubspec> {
  Pubspec(this.pathToProject) {
    if (!exists) {
      throw PathNotFoundException(pathToProject, const OSError());
    }
  }

  static const filename = 'pubspec.yaml';

  /// A path to project folder that contains [filename].
  final String pathToProject;

  /// A path to `pubspec.yaml` file for [projectId].
  String get pathToFile => p.join(pathToProject, filename).npath;

  WFile get file => WFile(pathToFile);

  bool get exists => file.existsFile();

  String get rawContent => file.readAsText()!;

  YamlMap get content => loadYaml(rawContent) as YamlMap;

  @override
  List<Object?> get props => [pathToProject];

  /// ! Compare by [pathToFile].
  @override
  int compareTo(Pubspec other) => pathToFile.compareTo(other.pathToFile);

  @override
  String toString() => pathToFile;
}
