part of '../fresher.dart';

/// A `pubspec.yaml` file.
class PubspecFile extends Equatable implements Comparable<PubspecFile> {
  const PubspecFile({
    required this.prefix,
    required this.projectId,
  }) : assert(projectId.length > 0);

  static const filename = 'pubspec.yaml';

  /// A prefix for path to [projectId].
  final String prefix;

  final String projectId;

  /// A path to `pubspec.yaml` file for [projectId].
  String get pathToFile => p.join(prefix, projectId, filename).npath;

  WFile get file => WFile(pathToFile);

  bool get exists => file.existsFile();

  String get rawContent => file.readAsText()!;

  YamlMap get content => loadYaml(rawContent) as YamlMap;

  @override
  List<Object?> get props => [prefix, projectId];

  /// ! Compare by [pathToFile].
  @override
  int compareTo(PubspecFile other) => pathToFile.compareTo(other.pathToFile);

  @override
  String toString() => pathToFile;
}
