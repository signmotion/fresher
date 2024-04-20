part of '../fresher.dart';

/// A [Pubspec] with options for freshing.
/// See [FreshPackage].
class FreshPubspec extends Pubspec {
  FreshPubspec(super.pathToProject);

  /// Returns a record: new content, upgraded packages, and skipped packages.
  Future<(String, List<FreshPackage>, List<FreshPackage>)> get upgraded async {
    final l = await outdated;
    var newContent = rawContentYaml;
    final upgradedPackages = <FreshPackage>[];
    final skippedPackages = <FreshPackage>[];
    for (final package in l.values) {
      if (package.currentYaml == package.resolvable ||
          package.weakCurrentYaml) {
        skippedPackages.add(package);
        continue;
      }

      // replace the text because we want to preserve the file format
      // example a line of dependency:
      // `uuid: ^4.1.0`
      final current = package.currentYaml.replaceFirst('^', '');
      final from = '${package.id}: ^$current';
      final to = '${package.id}: ^${package.resolvable}';
      final t = newContent.replaceFirst(from, to);
      if (t == newContent) {
        skippedPackages.add(package);
      } else {
        upgradedPackages.add(package);
        newContent = t;
      }
    }

    return (newContent, upgradedPackages, skippedPackages);
  }

  /// Outdated dependencies for [pathToProject] from pub.dev
  /// as [Map]<[String], [FreshPackage]>.
  /// See [outdatedAsJson].
  Future<Map<String, FreshPackage>> get outdated async {
    final l = await outdatedAsJson;

    final r = <String, FreshPackage>{};
    for (final o in l) {
      final key = o['package'] as String;
      r[key] = switch (o) {
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
            currentLock: current?['version'] as String? ?? '',
            currentYaml:
                FreshPackage.yamlFile(pathToFileYaml, package).currentYaml,
            upgradable: upgradable!['version'] as String? ?? '',
            resolvable: resolvable!['version'] as String? ?? '',
            latest: latest!['version'] as String? ?? '',
          ),
        _ => throw ArgumentError(l.sjson, 'l'),
      };
    }

    return r;
  }

  /// Outdated dependencies for [pathToProject]/[projectId] from pub.dev
  /// as [Iterable]<[JsonMap]>.
  /// See [outdated].
  Future<Iterable<JsonMap>> get outdatedAsJson async {
    const filterKinds = ['dev', 'direct'];

    const executable = 'dart';
    final args = ['pub', 'outdated', '--json', '--directory=$pathToProject'];
    final process = await Process.start(executable, args);
    final output = await process.stdout.transform(utf8.decoder).join(newLine);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      logger.i(output);
      logger.e(await process.stderr.transform(utf8.decoder).join(newLine));
      throw Exception('Process `$executable` with `$args` failed.'
          ' Exit code is $exitCode.');
    }

    return (output.jsonMap['packages'] as List<dynamic>)
        .map((e) => e as JsonMap)
        .where((e) => filterKinds.contains(e['kind']));
  }
}
