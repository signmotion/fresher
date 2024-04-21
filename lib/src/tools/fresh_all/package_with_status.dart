part of 'bloc.dart';

class PackageWithStatus implements Comparable<PackageWithStatus> {
  const PackageWithStatus({
    required this.package,
    required this.status,
  });

  final FreshPackage package;
  final UpdatedPackageStatus status;

  /// ! Group by [status.priority].
  @override
  int compareTo(PackageWithStatus other) => '$this'.compareTo('$other');

  @override
  String toString() => '$status\t${package.id} ${package.currentYaml}'
      '${status == UpdatedPackageStatus.modified ? package.resolvable : ""}';
}

enum UpdatedPackageStatus {
  undspecified(100),
  modified(1),
  unchanged(2);

  const UpdatedPackageStatus(this.priority);

  final int priority;

  String get coloredName => switch (name) {
        'unspecified' => spacedName.white.onRed,
        'modified' => spacedName.white.onYellow,
        'unchanged' => spacedName.gray,
        _ => spacedName,
      };

  String get spacedName => ' $name ';

  @override
  String toString() => '$priority $name';
}
