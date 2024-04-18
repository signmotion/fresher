part of 'bloc.dart';

class FreshAllState extends AState {
  const FreshAllState({
    required super.source,
    // services
    super.completed = const {},
    // own
    this.leaveSpaces = false,
    this.files = const [],
    this.projects = const [],
    this.sdks = const [],
    this.variables = const [],
    this.filesWithStatus = const {},
    this.error,
    this.stackTrace,
  });

  final bool leaveSpaces;

  final Iterable<FreshFile> files;
  final Iterable<FreshProject> projects;
  final Iterable<String> sdks;
  final Iterable<FreshVariable> variables;

  /// Key is [FreshProject.key].
  final Map<String, List<FileWithStatus>> filesWithStatus;

  final Object? error;
  final StackTrace? stackTrace;

  FreshAllState copyWith({
    Directory? source,
    Map<String, bool>? completed,
    // own
    bool? leaveSpaces,
    Iterable<FreshFile>? files,
    Iterable<FreshProject>? projects,
    Iterable<String>? sdks,
    Iterable<FreshVariable>? variables,
    Map<String, List<FileWithStatus>>? filesWithStatus,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      FreshAllState(
        source: source ?? this.source,
        completed: completed ?? this.completed,
        leaveSpaces: leaveSpaces ?? this.leaveSpaces,
        files: files ?? this.files,
        projects: projects ?? this.projects,
        sdks: sdks ?? this.sdks,
        variables: variables ?? this.variables,
        filesWithStatus: filesWithStatus ?? this.filesWithStatus,
        error: error ?? this.error,
        stackTrace: stackTrace ?? this.stackTrace,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        leaveSpaces,
        files,
        projects,
        sdks,
        variables,
        filesWithStatus,
        error,
        stackTrace,
      ];
}
