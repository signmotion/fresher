part of '../fresher.dart';

/// The project for refresh.
class FreshProject extends Equatable implements Comparable<FreshProject> {
  const FreshProject({
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
  int compareTo(FreshProject other) => '$this'.compareTo('$other');

  @override
  String toString() => '$sdk:$id';
}
