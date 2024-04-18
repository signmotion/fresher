part of '../fresher.dart';

/// A file for project updates.
class FreshFile extends Equatable implements Comparable<FreshFile> {
  const FreshFile({
    required this.key,
    required this.file,
  }) : assert(key.length > 0);

  /// A path to file into the project.
  /// Same a path to file into [Fresher] folder but without sdk path.
  final String key;

  /// A file from [Fresher] folder.
  final WFile file;

  bool get binary => file.binary();

  /// A raw value as [String].
  /// See [value], [rawValueAsBytes].
  String get rawValue => file.readAsText()!;

  /// A raw value as [String].
  /// See [rawValue].
  Uint8List get rawValueAsBytes => file.readAsBytes()!;

  /// A templated [rawValue].
  /// All `{{...}}` will replace to values from [variables].
  String value(Iterable<FreshVariable> variables) {
    final vars = FreshVariable.empty().mapped(variables);
    var r = rawValue;
    for (var prev = ''; r != prev; r = EmojiTemplate(r).renderString(vars)) {
      prev = r;
    }

    return r;
  }

  Uint8List valueAsBytes(Iterable<FreshVariable> variables) =>
      Uint8List.fromList(utf8.encode(value(variables)));

  /// A path into the project.
  String pathToFileForUpdate(String prefix, String projectId) =>
      p.join(prefix, projectId, key).npath;

  @override
  List<Object?> get props => [key];

  /// ! Compare by [key].
  @override
  int compareTo(FreshFile other) => key.compareTo(other.key);

  @override
  String toString() => '$key : ${file.npath}';
}
