part of '../fresher.dart';

/// Resolutions when a file conflict appears.
enum FileConflictResolution {
  unspecified,

  /// A file will be overwrite.
  overwrite,

  /// A file will be skipped when present and added otherwise.
  doNotOverwrite,
}
