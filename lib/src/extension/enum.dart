part of '_.dart';

/// ! Copied from <https://github.com/signmotion/dart_helper>.
extension FresherEnumExt on Iterable<Enum> {
  /// Example:
  /// ```
  /// UnitType.values.findByName(s, defaults: UnitType.m);
  /// ```
  T? findByName<T>(
    String name, {
    T? defaults,
  }) =>
      (firstWhereOrNull((e) => e.name == name) ?? defaults) as T?;
}
