import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:cli_table/cli_table.dart';
import 'package:collection/collection.dart';
import 'package:wfile/wfile.dart';

import '../../../fresher.dart';
import '../../common/bloc.dart';
import '../../utils/log.dart';

part 'events.dart';
part 'file_with_status.dart';
part 'fresh_all.dart';
part 'result.dart';
part 'state.dart';

class FreshAllBloc extends ABloc<AEvent, FreshAllState> {
  FreshAllBloc(FresherOptions options)
      : super(FreshAllState(options: options)) {
    on<AEvent>(
      _onEvent,
      transformer: sequential(),
    );
  }

  Future<void> _onEvent(
    AEvent event,
    Emitter<FreshAllState> emit,
  ) async =>
      switch (event) {
        // fresh all projects
        GettingSdksEvent e => _onGettingSdksEvent(e, emit),
        GettingFreshFilesEvent e => _onGettingFreshFilesEvent(e, emit),
        GettingFreshProjectsEvent e => _onGettingFreshProjectsEvent(e, emit),
        GettingFreshVariablesEvent e => _onGettingFreshVariablesEvent(e, emit),
        FreshingProjectFilesEvent e => _onFreshingProjectFilesEvent(e, emit),
        UpgradingProjectDependenciesEvent e =>
          _onUpgradingProjectDependenciesEvent(e, emit),
        OutputEvent e => _onOutputEvent(e, emit),
        // unsupported event
        AEvent() => throw Exception('Unsupported event: $event'),
      };

  Fresher get fresher => Fresher(state.options);

  Future<void> _onGettingSdksEvent(
    GettingSdksEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = '$event';
    unsetCompleted(key);

    emit(state.copyWith(sdks: fresher.sdks));

    setCompleted(key);
  }

  Future<void> _onGettingFreshFilesEvent(
    GettingFreshFilesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = event.project.key;
    unsetCompleted(key);

    emit(state.copyWith(
      files: fresher.projectFiles(
        event.project.sdk,
        event.project.id,
      ),
    ));

    setCompleted(key);
  }

  Future<void> _onGettingFreshProjectsEvent(
    GettingFreshProjectsEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = '$event';
    unsetCompleted(key);

    emit(state.copyWith(projects: fresher.projects));

    setCompleted(key);
  }

  Future<void> _onGettingFreshVariablesEvent(
    GettingFreshVariablesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = event.project.key;
    unsetCompleted(key);

    emit(state.copyWith(
      variables: fresher.projectVariables(
        event.project.sdk,
        event.project.id,
      ),
    ));

    setCompleted(key);
  }

  Future<void> _onFreshingProjectFilesEvent(
    FreshingProjectFilesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final project = event.project;
    final key = '$event-${project.key}';
    unsetCompleted(key);

    final files = fresher.projectFiles(project.sdk, project.id);
    final variables = fresher.projectVariables(project.sdk, project.id);
    for (final file in files) {
      final from = file.file.npath;
      final to = file.pathToFileForUpdate('..', project.id);
      event.output('$from\n  -> $to');
      if (file.fileConflictResolution != FileConflictResolution.overwrite) {
        event.output(
            '  with conflict resolution ${file.fileConflictResolution.name}');
      }

      final fileTo = WFile(to);
      final prevContent = fileTo.readAsBytes();
      final content =
          file.binary ? file.rawValueAsBytes : file.valueAsBytes(variables);

      late final UpdatedStatus status;
      if (prevContent == null) {
        status = UpdatedStatus.added;
      } else if (file.fileConflictResolution ==
          FileConflictResolution.doNotOverwrite) {
        status = UpdatedStatus.skipped;
      } else if (content.toList().equals(prevContent.toList())) {
        status = UpdatedStatus.unchanged;
      } else {
        status = UpdatedStatus.modified;
      }

      const writes = [UpdatedStatus.added, UpdatedStatus.modified];
      if (writes.contains(status)) {
        fileTo.writeAsBytes(content);
      }

      final prevs = state.filesWithStatus[key] ?? [];
      final l = <String, List<FileWithStatus>>{
        ...state.filesWithStatus,
        key: [...prevs, FileWithStatus(file: file, status: status)],
      };
      emit(state.copyWith(filesWithStatus: l));

      event.output('  ${status.name}');
    }

    setCompleted(key);
  }

  Future<void> _onUpgradingProjectDependenciesEvent(
    UpgradingProjectDependenciesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final project = event.project;
    final key = '$event-${project.key}';
    unsetCompleted(key);

    final path = pathToProjectWithPrefix('..', project.id).npath;
    event.output('Looking `pubspec.yaml` by path `$path`...');
    final pubspec = FreshPubspec(path);

    event.output('Removing `${pubspec.pathToFileLock}`...');
    pubspec.removeLock();
    event.output('Removed `${pubspec.pathToFileLock}`.');

    // final outdated = await pubspec.outdated;
    // for (final package in outdated.values) {
    //   print('$package');
    // }

    event.output('Upgrading `${pubspec.pathToFileYaml}`...');
    final (newContent, upgradedPackages, skippedPackages) =
        await pubspec.upgraded;
    pubspec.writeYaml(newContent);
    final countPackages = upgradedPackages.length + skippedPackages.length;
    event.output('Upgraded ${upgradedPackages.length}/$countPackages packages'
        ' into `${pubspec.pathToFileYaml}`.');

    // final pubspec = Pubspec('../${project.id}');
    // final d = pubspec.content;
    // final dependencies = {
    //   ...d['dependencies'] as YamlMap,
    //   ...d['dev_dependencies'] as YamlMap,
    // };
    // for (final e in dependencies.entries) {
    //   print(e);
    //   final package = FreshPackage(
    //     id: e.key as String,
    //     currentYaml: e.value as String,
    //   );
    //   final latestVersion = await package.getLatestVersion;
    //   print('$package, latest version `$latestVersion`');
    // }

    event.output('Upgraded `pubspec.yaml` by path `$path`.');

    setCompleted(key);
  }

  Future<void> _onOutputEvent(
    OutputEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    event.output(event.s);
  }

  @override
  // ignore: invalid_use_of_visible_for_testing_member
  void setCompleted(String key, [bool value = true]) => emit(
        state.copyWith(
          completed: {...state.completed, key: value},
        ),
      );
}
