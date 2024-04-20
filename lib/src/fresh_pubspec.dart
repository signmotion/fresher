part of '../fresher.dart';

/// A [Pubspec] with options for freshing.
/// See [FreshPackage].
class FreshPubspec extends Pubspec {
  FreshPubspec(super.pathToProject);

  /// Outdated dependencies for [pathToProject] from pub.dev
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
              currentYaml:
                  FreshPackage.yamlFile(pathToProject, package).currentYaml,
              upgradable: upgradable!['version'] as String? ?? '',
              resolvable: resolvable!['version'] as String? ?? '',
              latest: latest!['version'] as String? ?? '',
            ),
          _ => throw ArgumentError(l.sjson, 'l'),
        }
    };
  }

  /// Outdated dependencies for [pathToProject]/[projectId] from pub.dev
  /// as [List]<[JsonMap]>.
  /// See [outdated].
  Future<List<JsonMap>> get outdatedAsJson async {
    const executable = 'dart';
    final args = ['pub', 'outdated', '--json', '--directory="$pathToProject"'];
    final process = await Process.start(executable, args);
    final output = await process.stdout.transform(utf8.decoder).join(newLine);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception('Process `$executable` with `$args` failed.'
          ' Exit code is $exitCode.');
    }

    return output.jsonMap['packages'] as List<JsonMap>;
  }
}
