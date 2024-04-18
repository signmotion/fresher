part of 'bloc.dart';

class FileWithStatus {
  const FileWithStatus({
    required this.file,
    required this.status,
  });

  final FreshFile file;
  final UpdatedStatus status;

  @override
  String toString() => '${status.name}\t$file';
}

enum UpdatedStatus {
  undspecified(),
  added(),
  modified(),
  skipped(),
  unchanged();

  const UpdatedStatus();

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
