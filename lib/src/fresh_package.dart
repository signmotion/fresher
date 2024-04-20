part of '../fresher.dart';

/// The package for refresh.
class FreshPackage extends Equatable implements Comparable<FreshPackage> {
  const FreshPackage({
    required this.id,
    this.version = '',
  }) : assert(id.length > 0);

  /// An ID of package on pub.dev.
  final String id;

  /// A version of the package.
  final String version;

  bool get hasVersion => version.isNotEmpty;

  /// Parse a text [version] to [semver](https://semver.org/spec/v2.0.0-rc.1.html).
  /// Thanks [pub_semver](https://pub.dev/packages/pub_semver).
  /// See [checkVersion], [hasVersion].
  Version? get semVer => hasVersion ? Version.parse(version) : null;

  /// Checks a syntax of [version] and `false` when [version] is empty.
  /// See [semVer].
  bool get checkVersion {
    if (!hasVersion) {
      return false;
    }

    try {
      semVer;
    } on FormatException catch (_) {
      return false;
    }

    return true;
  }

  /// A latest version from pub.dev.
  /// Thanks [pub_updater](https://pub.dev/packages/pub_updater).
  Future<String> get latestVersion => PubUpdater().getLatestVersion(id);

  @override
  List<Object?> get props => [id, version];

  /// ! Compare by [id] and [version].
  @override
  int compareTo(FreshPackage other) => '$this'.compareTo('$other');

  @override
  String toString() => '$id${hasVersion ? " $version" : ""}';
}
