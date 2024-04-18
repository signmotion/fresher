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
        'unspecified' => name.white.onRed,
        'added' => name.white.onGreen,
        'modified' => name.white.onYellow,
        'skipped' => name.white.onGray,
        'unchanged' => name.gray,
        _ => name.yellowBright,
      };
}
