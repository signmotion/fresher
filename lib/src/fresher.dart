part of '../fresher.dart';

/// Access to data for refreshing projects files from source.
class Fresher {
  const Fresher(
    this.source, {
    required this.leaveSpaces,
  });

  final String source;
  final bool leaveSpaces;

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
    return allFiles(path, rootFileConflictResolutions()).toList()..sort();
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
      ...allFiles(path, sdkFileConflictResolutions(sdk)),
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
      ...allFiles(path, projectFileConflictResolutions(sdk, projectId)),
      ...sdkFiles(sdk),
    }.toList()
      ..sort();
  }

  /// A set of all [FileConflictResolution]s from [source], folder [freshPrefix].
  Map<String, FileConflictResolution> rootFileConflictResolutions() =>
      allFileConflictResolution(
        p.join(source, fresherPrefix, fresherFile),
      );

  /// A set of all [FileConflictResolution]s from [source]/[sdk], folder [freshPrefix].
  Map<String, FileConflictResolution> sdkFileConflictResolutions(String sdk) =>
      {
        ...allFileConflictResolution(
          p.join(source, sdk, fresherPrefix, fresherFile),
        ),
        ...rootFileConflictResolutions(),
      };

  /// A set of all [FileConflictResolution]s from [source]/[sdk]/[projectId],
  /// folder [freshPrefix].
  Map<String, FileConflictResolution> projectFileConflictResolutions(
    String sdk,
    String projectId,
  ) =>
      {
        ...allFileConflictResolution(
          p.join(source, sdk, projectId, fresherPrefix, fresherFile),
        ),
        ...sdkFileConflictResolutions(sdk),
      };

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
  Iterable<FreshProject> get projects => sdks
      .map((sdk) => p.join(source, sdk))
      .map((sourceSdk) => Directory(sourceSdk)
          .listSync()
          .whereType<Directory>()
          .where((e) => !e.isFresherDirectory && !e.isServiceEntity)
          .map((e) => FreshProject(
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

  /// A resolution by [key].
  /// Default: [FileConflictResolution.overwrite].
  static FileConflictResolution fileConflictResolution(
    String key,
    Map<String, FileConflictResolution> resolutions,
  ) =>
      resolutions[key] ?? FileConflictResolution.overwrite;

  /// All [FreshFile]s by [path].
  Iterable<FreshFile> allFiles(
    String path,
    Map<String, FileConflictResolution> resolutions,
  ) =>
      Directory(path)
          .listSync(recursive: true)
          .whereType<File>()
          .where((e) => !e.containsFresherEntity(path))
          .map(
            (file) => FreshFile(
              key: file.fresherKeyEntity(path),
              file: WFile(file),
              fileConflictResolution: fileConflictResolution(
                file.fresherKeyEntity(path),
                resolutions,
              ),
            ),
          );

  /// All [FreshVariable]s from [fresherFile] by [path].
  Map<String, FileConflictResolution> allFileConflictResolution(String path) {
    final w = WFile(path);
    if (!w.existsFile()) {
      return const {};
    }

    final s = w.readAsText()!;
    final d = loadYaml(s) as YamlMap;
    final resolutions = d['file_conflict_resolutions'] as YamlList? ?? [];

    final map = <String, FileConflictResolution>{};
    for (final r in resolutions) {
      final o = switch (r) {
        {
          'name': String? name,
          'resolution': String? resolution,
        } =>
          (name ?? '', resolution ?? ''),
        _ => throw ArgumentError(r, 'resolutions'),
      };
      map[o.$1] = FileConflictResolution.values
          .findByName(o.$2, defaults: FileConflictResolution.unspecified)!;
    }

    return map;
  }

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
          leaveSpaces: leaveSpaces,
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
        leaveSpaces: leaveSpaces,
      );
    });

    Iterable<FreshVariable> look(WFile w) => w.basename == fresherFile
        ? allFileVariables(w.path, sdk: sdk, projectId: projectId)
        : [
            FreshVariable(
              scope: scope(w.npath, sdk: sdk, projectId: projectId),
              names: FreshVariable.generateNames(w.basenameWithoutExtension),
              rawValue: w.readAsText()!,
              leaveSpaces: leaveSpaces,
            )
          ];

    return [for (final file in files) ...look(WFile(file))];
  }
}
