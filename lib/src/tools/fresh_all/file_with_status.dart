part of 'bloc.dart';

class FileWithStatus implements Comparable<FileWithStatus> {
  const FileWithStatus({
    required this.file,
    required this.status,
  });

  final FreshFile file;
  final UpdatedStatus status;

  /// ! Group by [status.priority].
  @override
  int compareTo(FileWithStatus other) => '${status.priority} $file'
      .compareTo('${other.status.priority} ${other.file}');

  @override
  String toString() => '${status.name}\t$file';
}

enum UpdatedStatus {
  undspecified(100),
  added(2),
  modified(1),
  skipped(3),
  unchanged(4);

  const UpdatedStatus(this.priority);

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
}
