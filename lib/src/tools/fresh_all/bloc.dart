import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:wfile/wfile.dart';

import '../../../fresher.dart';
import '../../common/bloc.dart';

part 'events.dart';
part 'file_with_status.dart';
part 'fresh_all.dart';
part 'result.dart';
part 'state.dart';

class FreshAllBloc extends ABloc<AEvent, FreshAllState> {
  FreshAllBloc(Directory source) : super(FreshAllState(source: source)) {
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
        GettingFreshFilesEvent e => _onGettingFreshFilesEvent(e, emit),
        GettingFreshProjectsEvent e => _onGettingFreshProjectsEvent(e, emit),
        GettingFreshVariablesEvent e => _onGettingFreshVariablesEvent(e, emit),
        GettingSdksEvent e => _onGettingSdksEvent(e, emit),
        FreshingProjectEvent e => _onFreshingProjectEvent(e, emit),
        OutputEvent e => _onOutputEvent(e, emit),
        // unsupported event
        AEvent() => throw Exception('Unsupported event: $event'),
      };

  Fresher get fresher => Fresher(state.source.path);

  Future<void> _onGettingFreshFilesEvent(
    GettingFreshFilesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = event.project.id;
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
    final key = event.project.id;
    unsetCompleted(key);

    emit(state.copyWith(
      variables: fresher.projectVariables(
        event.project.sdk,
        event.project.id,
      ),
    ));

    setCompleted(key);
  }

  Future<void> _onFreshingProjectEvent(
    FreshingProjectEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final project = event.project;
    final key = project.id;
    unsetCompleted(key);

    final files = fresher.projectFiles(project.sdk, project.id);
    final variables = fresher.projectVariables(project.sdk, project.id);
    for (final file in files) {
      final from = file.file.npath;
      final to = file.pathToFileForUpdate('..', project.id);
      event.output('$from\n  -> $to');

      final prevContent = WFile(to).readAsBytes();
      final content =
          file.binary ? file.rawValueAsBytes : file.value(variables);

      late final UpdatedStatus status;
      if (prevContent == null) {
        status = UpdatedStatus.added;
      } else if (content == prevContent) {
        status = UpdatedStatus.unchanged;
      } else {
        status = UpdatedStatus.overwritten;
      }

      final l = [
        ...state.filesWithStatus,
        FileWithStatus(file: file, status: status),
      ];
      emit(state.copyWith(filesWithStatus: l));

      event.output('  ${status.name}');
    }

    setCompleted(key);
  }

  Future<void> _onGettingSdksEvent(
    GettingSdksEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    final key = '$event';
    unsetCompleted(key);

    emit(state.copyWith(sdks: fresher.sdks));

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
