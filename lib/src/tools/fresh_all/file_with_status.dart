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
  undspecified,
  added,
  overwritten,
  skipped,
  unchanged,
}
