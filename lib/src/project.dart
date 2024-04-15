part of '../fresher.dart';

/// The project for refresh.
class Project extends Equatable implements Comparable<Project> {
  const Project({
    required this.sdk,
    required this.id,
  })  : assert(sdk.length > 0),
        assert(id.length > 0);

  /// An SDK (same folder name contains projects).
  final String sdk;

  /// An ID (same folder name).
  final String id;

  @override
  List<Object?> get props => [sdk, id];

  @override
  int compareTo(Project other) => '$this'.compareTo('$other');

  @override
  String toString() => '$sdk:$id';
}
