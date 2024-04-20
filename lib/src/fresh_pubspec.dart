part of '../fresher.dart';

/// A [Pubspec] with options for freshing.
/// See [FreshPackage].
class FreshPubspec extends Pubspec {
  const FreshPubspec({
    required super.prefix,
    required super.projectId,
  });

  String get path => p.join(prefix, projectId);

  /// Outdated dependencies for [prefix]/[projectId] from pub.dev
  /// as [Map]<[String], [FreshPackage]>.
  /// See [outdatedAsJson].
  Future<Map<String, FreshPackage>> get outdated async {
    final l = await outdatedAsJson;

    return {
      for (final o in l)
        o['package'] as String: switch (o) {
          {
            'package': String? package,
            'kind': String? kind,
            'isDiscontinued': bool? isDiscontinued,
            'current': Map<String, dynamic>? current,
            'upgradable': Map<String, dynamic>? upgradable,
            'resolvable': Map<String, dynamic>? resolvable,
            'latest': Map<String, dynamic>? latest,
          } =>
            FreshPackage(
              id: package!,
              kind: kind ?? '',
              isDiscontinued: isDiscontinued ?? false,
              currentLock: current!['version'] as String? ?? '',
              currentYaml: FreshPackage.yamlFile(path, package).currentYaml,
              upgradable: upgradable!['version'] as String? ?? '',
              resolvable: resolvable!['version'] as String? ?? '',
              latest: latest!['version'] as String? ?? '',
            ),
          _ => throw ArgumentError(l.sjson, 'l'),
        }
    };
  }

  /// Outdated dependencies for [prefix]/[projectId] from pub.dev
  /// as [List]<[JsonMap]>.
  /// See [outdated].
  Future<List<JsonMap>> get outdatedAsJson async {
    const executable = 'dart';
    final args = ['pub', 'outdated', '--json', '--directory="$path"'];
    final process = await Process.start(executable, args);
    final output = await process.stdout.transform(utf8.decoder).join('\n');
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception(
          'Process `$executable` `$args` failed with exit code $exitCode.');
    }

    return output.jsonMap['packages'] as List<JsonMap>;
  }
}
