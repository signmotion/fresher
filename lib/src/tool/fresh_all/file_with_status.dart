part of 'bloc.dart';

class FileWithStatus implements Comparable<FileWithStatus> {
  const FileWithStatus({
    required this.file,
    required this.status,
  });

  final FreshFile file;
  final UpdatedFileStatus status;

  /// ! Group by [status.priority].
  @override
  int compareTo(FileWithStatus other) => '$this'.compareTo('$other');

  @override
  String toString() => '$status\t$file';
}

enum UpdatedFileStatus {
  undspecified(100),
  added(1),
  modified(2),
  skipped(3),
  unchanged(4);

  const UpdatedFileStatus(this.priority);

  final int priority;

  String get coloredName => switch (name) {
        'unspecified' => spacedName.white.onRed,
        'added' => spacedName.white.onGreen,
        'modified' => spacedName.white.onYellow,
        'skipped' => spacedName.white.onGray,
        'unchanged' => spacedName.gray,
        _ => spacedName,
      };

  String get spacedName => ' $name ';

  @override
  String toString() => '$priority $name';
}
