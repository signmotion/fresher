part of '_.dart';

extension FresherFileSystemEntityExt on FileSystemEntity {
  /// See [containsFresherEntity].
  bool get isFresherEntity => isFresherDirectory || isFresherFile;

  /// Contains [Directory] or [File] in the path.
  bool containsFresherEntity(String prefix) =>
      p
          .split(fresherKeyEntity(prefix))
          .firstWhereOrNull((e) => e.startsWith(fresherPrefix)) !=
      null;

  /// See [containsFresherEntity].
  bool get isFresherDirectory =>
      this is Directory && p.basename(path).startsWith(fresherPrefix);

  /// See [containsFresherEntity].
  bool get isFresherFile =>
      this is File && p.basename(path).startsWith(fresherPrefix);

  /// Detects [fresherOutputFolder].
  bool get isInFresherOutputFolder =>
      p.split(path).contains(fresherOutputFolder);

  /// Service files and folders detecting by [servicePrefix] prefix.
  bool get isServiceEntity => p.basename(path).startsWith(servicePrefix);

  /// [normalizedPath] without [prefix].
  String fresherKeyEntity(String prefix) =>
      normalizedPath.replaceFirst(prefix.normalizedPath, '').substring(1);

  /// Trimmed path with replaced `\` to `/`.
  String get normalizedPath => path.normalizedPath;
}
