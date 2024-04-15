part of '../fresher.dart';

/// Access to data for refreshing projects files from source.
class Fresher {
  const Fresher(this.source);

  final String source;

  /// [path] without [source], [sdk], [projectId] and with some modification.
  String scope(
    String path, {
    String? sdk,
    String? projectId,
  }) {
    var r = path.normalizedPath
        .replaceFirst(source.normalizedPath, '')
        .replaceFirst('$fresherPrefix/', '')
        .replaceFirst('//', '')
        .toLowerCase();
    if (r.startsWith('/')) {
      r = r.substring(1);
    }
    if (sdk != null) {
      r = r.replaceFirst('$sdk/', '');
    }
    if (projectId != null) {
      r = r.replaceFirst('$projectId/', '');
    }
    if (r == fresherFile) {
      return '';
    }

    if (r.endsWith(fresherFile)) {
      r = r.substring(0, r.length - fresherFile.length - 1);
    }
    if (r.isEmpty) {
      return '';
    }

    final pr = p.split(r).map((e) {
      final noPrefix = e.startsWith(fresherPrefix) ? e.substring(1) : e;
      return p.basenameWithoutExtension(noPrefix);
    });

    return pr.first;
  }

  /// A set of all [File] from [source], folder [freshPrefix].
  /// Ignores empty [Directory]s.
  Iterable<FreshFile> rootFiles() {
    final path = p.join(source, fresherPrefix);
    return allFiles(path).toList()..sort();
  }

  /// A set of all variables from [source], folder [freshPrefix],
  /// file [fresherFile] and files starts with [freshPrefix].
  Iterable<FreshVariable> rootVariables() => {
        ...allFileVariables(p.join(source, fresherPrefix, fresherFile)),
        ...allScopeFilesVariables(p.join(source, fresherPrefix)),
      }.toList()
        ..sort();

  /// A set of all [File] from [source]/[sdk], folder [freshPrefix].
  /// Ignores empty [Directory]s.
  Iterable<FreshFile> sdkFiles(String sdk) {
    final path = p.join(source, sdk, fresherPrefix);
    return {
      ...allFiles(path),
      ...rootFiles(),
    }.toList()
      ..sort();
  }

  /// A set of all variables from [source]/[sdk], folder [freshPrefix].
  /// Ignores empty [Directory]s.
  Iterable<FreshVariable> sdkVariables(String sdk) => {
        ...allFileVariables(
          p.join(source, sdk, fresherPrefix, fresherFile),
          sdk: sdk,
        ),
        ...allScopeFilesVariables(p.join(source, sdk, fresherPrefix), sdk: sdk),
        ...rootVariables(),
      }.toList()
        ..sort();

  /// A set of all [File] from [source]/[sdk]/[projectId], folder [freshPrefix].
  /// Ignores empty [Directory]s.
  Iterable<FreshFile> projectFiles(String sdk, String projectId) {
    final path = p.join(source, sdk, projectId, fresherPrefix);
    return {
      ...allFiles(path),
      ...sdkFiles(sdk),
    }.toList()
      ..sort();
  }

  /// A set of all variables from [source]/[sdk]/[projectId], folder [freshPrefix].
  /// Ignores empty [Directory]s.
  Iterable<FreshVariable> projectVariables(String sdk, String projectId) => {
        ...allFileVariables(
          p.join(
            source,
            sdk,
            projectId,
            fresherPrefix,
            fresherFile,
          ),
          sdk: sdk,
          projectId: projectId,
        ),
        ...allScopeFilesVariables(
          p.join(
            source,
            sdk,
            projectId,
            fresherPrefix,
          ),
          sdk: sdk,
          projectId: projectId,
        ),
        ...sdkVariables(sdk),
      }.toList()
        ..sort();

  /// A set of all projects from all [sdks].
  Iterable<Project> get projects => sdks
      .map((sdk) => p.join(source, sdk))
      .map((sourceSdk) => Directory(sourceSdk)
          .listSync()
          .whereType<Directory>()
          .where((e) => !e.isFresherDirectory && !e.isServiceEntity)
          .map((e) => Project(
                sdk: p.basename(e.parent.path),
                id: p.basename(e.path),
              )))
      .expand((e) => e)
      .toList()
    ..sort();

  /// A set of all SDKs from [source].
  Iterable<String> get sdks => Directory(source)
      .listSync()
      .whereType<Directory>()
      .where((e) => !e.isFresherDirectory && !e.isServiceEntity)
      .map((e) => p.basename(e.path))
      .toList()
    ..sort();

  /// All [FreshFile]s by [path].
  Iterable<FreshFile> allFiles(String path) => Directory(path)
      .listSync(recursive: true)
      .whereType<File>()
      .where((e) => !e.containsFresherEntity(path))
      .map((file) => FreshFile(
            key: file.fresherKeyEntity(path),
            file: WFile(file),
          ));

  /// All [FreshVariable]s from [fresherFile] by [path].
  Iterable<FreshVariable> allFileVariables(
    String path, {
    String? sdk,
    String? projectId,
  }) {
    final w = WFile(path);
    if (!w.existsFile()) {
      return const [];
    }

    final s = w.readAsText()!;
    final d = loadYaml(s) as YamlMap;
    final variables = d['variables'] as YamlMap;

    final sc = scope(path, sdk: sdk, projectId: projectId);

    return [
      for (final e in variables.entries)
        FreshVariable(
          scope: sc,
          names: FreshVariable.generateNames(e.key as String? ?? ''),
          rawValue: '${e.value}',
        )
    ];
  }

  /// All [FreshVariable]s from directories (mean file) by [path].
  Iterable<FreshVariable> allScopeFilesVariables(
    String path, {
    String? sdk,
    String? projectId,
  }) {
    final dirs = Directory(path)
        .listSync()
        .whereType<Directory>()
        .where(
            (dir) => dir.isFresherDirectory && !dir.path.endsWith(fresherFile))
        .toList();
    final files = dirs
        .map((dir) => dir.listSync().whereType<File>())
        .expand((e) => e)
        .toList();

    files.map((file) {
      final w = WFile(file);
      final sc = scope(w.npath, sdk: sdk, projectId: projectId);
      return FreshVariable(
        scope: sc,
        names: FreshVariable.generateNames(w.basenameWithoutExtension),
        rawValue: w.readAsText()!,
      );
    });

    Iterable<FreshVariable> look(WFile w) => w.basename == fresherFile
        ? allFileVariables(w.path, sdk: sdk, projectId: projectId)
        : [
            FreshVariable(
              scope: scope(w.npath, sdk: sdk, projectId: projectId),
              names: FreshVariable.generateNames(w.basenameWithoutExtension),
              rawValue: w.readAsText()!,
            )
          ];

    return [for (final file in files) ...look(WFile(file))];
  }
}
