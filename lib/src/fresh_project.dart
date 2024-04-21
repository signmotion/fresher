part of '../fresher.dart';

/// The project for refresh.
class FreshProject extends Equatable implements Comparable<FreshProject> {
  const FreshProject({
    required this.sdk,
    required this.id,
  }) : assert(id.length > 0);

  /// Compounded [sdk] and [id].
  String get key => '$sdk:$id';

  /// An SDK (same folder name contains projects).
  final String sdk;

  /// An ID (same folder name).
  final String id;

  @override
  List<Object?> get props => [sdk, id];

  /// ! Compare by [key].
  @override
  int compareTo(FreshProject other) => key.compareTo(other.key);

  @override
  String toString() => key;
}
