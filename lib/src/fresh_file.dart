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

  /// A raw value.
  /// See [value].
  String get rawValue => file.readAsText()!;

  /// A templated [rawValue].
  /// All `{{...}}` will replace to values from [variables].
  String value(Iterable<FreshVariable> variables) => EmojiTemplate(rawValue)
      .renderString(FreshVariable.empty().mapped(variables));

  @override
  List<Object?> get props => [key];

  /// ! Compare by [key].
  @override
  int compareTo(FreshFile other) => '$this'.compareTo('$other');

  @override
  String toString() => '$key : ${file.npath}';
}
