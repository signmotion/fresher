part of '_.dart';

extension FresherStringFileSystemEntityExt on String {
  /// Trimmed path with replaced `\` to `/`.
  String get normalizedPath => trim().replaceAll(r'\', '/');
}
