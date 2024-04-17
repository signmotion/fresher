part of 'bloc.dart';

class FreshAllState extends AState {
  const FreshAllState({
    required super.source,
    // services
    super.completed = false,
    // own
    this.files = const [],
    this.projects = const [],
    this.sdks = const [],
    this.variables = const [],
    this.filesWithStatus = const [],
  });

  final Iterable<FreshFile> files;
  final Iterable<FreshProject> projects;
  final Iterable<String> sdks;
  final Iterable<FreshVariable> variables;

  final List<FileWithStatus> filesWithStatus;

  FreshAllState copyWith({
    Directory? source,
    bool? completed,
    // own
    Iterable<FreshFile>? files,
    Iterable<FreshProject>? projects,
    Iterable<String>? sdks,
    Iterable<FreshVariable>? variables,
    List<FileWithStatus>? filesWithStatus,
  }) =>
      FreshAllState(
        source: source ?? this.source,
        completed: completed ?? this.completed,
        files: files ?? this.files,
        projects: projects ?? this.projects,
        sdks: sdks ?? this.sdks,
        variables: variables ?? this.variables,
        filesWithStatus: filesWithStatus ?? this.filesWithStatus,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        files,
        projects,
        sdks,
        variables,
        filesWithStatus,
      ];
}
