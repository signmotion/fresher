part of '../fresher.dart';

/// A variable for files project updates.
class FreshVariable extends Equatable implements Comparable<FreshVariable> {
  const FreshVariable({
    required this.scope,
    required this.names,
    required this.rawValue,
  }) : assert(names.length > 0);

  factory FreshVariable.empty() =>
      FreshVariable(scope: '', names: const [''], rawValue: '');

  /// Look at <https://pub.dev/packages/recase>. All from the link above,
  /// but exluded:
  ///   - pathCase
  static Set<String> generateNames(String baseName) {
    final s = ReCase(baseName);
    return {baseName}..addAll([
        s.snakeCase,
        s.constantCase,
        s.dotCase,
        //s.pathCase,
        s.paramCase,
        s.pascalCase,
        s.headerCase,
        s.titleCase,
        s.camelCase,
        s.sentenceCase,
        baseName.toLowerCase(),
        baseName.toUpperCase(),
      ]);
  }

  /// A scope.
  /// Same **base file name** without extension or empty for root variable.
  final String scope;

  /// A name and its aliases.
  /// See [scope], [name].
  final Iterable<String> names;

  /// The first name from [names].
  String get name => names.first;

  /// A [names] with [scope].
  /// See [fullName].
  Iterable<String> get fullNames => names.map((name) => '$scope.$name');

  /// The first full name from [fullNames].
  String get fullName => fullNames.first;

  /// `true` if [name] able in [names] or [fullNames].
  bool hasName(String name) => names.contains(name) || fullNames.contains(name);

  /// A raw value.
  /// See [value].
  final String rawValue;

  /// A templated [rawValue].
  /// All `{{...}}` will replace to values from [variables].
  String value(Iterable<FreshVariable> variables) =>
      EmojiTemplate(rawValue).renderString(mapped(variables));

  /// Map with [name] (key) and [rawValue] (value) but excluded this [name].
  Map<String, dynamic> mapped(Iterable<FreshVariable> variables) {
    final l = variables.whereNot((v) => v.hasName(name)).toList();
    return {for (final v in l) v.name: v.rawValue};
  }

  @override
  List<Object?> get props => [fullName];

  /// ! Compare by [fullName].
  @override
  int compareTo(FreshVariable other) => fullName.compareTo(other.fullName);

  @override
  String toString() => '$scope.$names = `$rawValue`';
}
