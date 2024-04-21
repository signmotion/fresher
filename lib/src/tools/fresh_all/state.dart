part of 'bloc.dart';

class FreshAllState extends AState {
  const FreshAllState({
    required this.options,
    // services
    super.completed = const {},
    // own
    this.files = const [],
    this.projects = const [],
    this.sdks = const [],
    this.variables = const [],
    this.filesWithStatus = const {},
    this.packagesWithStatus = const {},
    this.error,
    this.stackTrace,
  });

  /// See [o].
  final FresherOptions options;

  /// Alias for [options].
  FresherOptions get o => options;

  final Iterable<FreshFile> files;
  final Iterable<FreshProject> projects;
  final Iterable<String> sdks;
  final Iterable<FreshVariable> variables;

  /// Key is [FreshProject.key].
  final Map<String, Iterable<FileWithStatus>> filesWithStatus;

  /// Key is [FreshPackage.key].
  final Map<String, Iterable<PackageWithStatus>> packagesWithStatus;

  final Object? error;
  final StackTrace? stackTrace;

  FreshAllState copyWith({
    FresherOptions? options,
    // services
    Map<String, bool>? completed,
    // own
    bool? leaveSpaces,
    Iterable<FreshFile>? files,
    Iterable<FreshProject>? projects,
    Iterable<String>? sdks,
    Iterable<FreshVariable>? variables,
    Map<String, Iterable<FileWithStatus>>? filesWithStatus,
    Map<String, Iterable<PackageWithStatus>>? packagesWithStatus,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      FreshAllState(
        options: options ?? this.options,
        completed: completed ?? this.completed,
        files: files ?? this.files,
        projects: projects ?? this.projects,
        sdks: sdks ?? this.sdks,
        variables: variables ?? this.variables,
        filesWithStatus: filesWithStatus ?? this.filesWithStatus,
        packagesWithStatus: packagesWithStatus ?? this.packagesWithStatus,
        error: error ?? this.error,
        stackTrace: stackTrace ?? this.stackTrace,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        options,
        files,
        projects,
        sdks,
        variables,
        filesWithStatus,
        packagesWithStatus,
        error,
        stackTrace,
      ];
}
