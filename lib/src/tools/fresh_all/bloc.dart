import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../../fresher.dart';
import '../../common/bloc.dart';

part 'events.dart';
part 'file_with_status.dart';
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
        // unsupported event
        AEvent() => throw Exception('Unsupported event: $event'),
      };

  Fresher get fresher => Fresher(state.source.path);

  Future<void> _onGettingFreshFilesEvent(
    GettingFreshFilesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    emit(state.copyWith(completed: false));
    emit(state.copyWith(
      files: fresher.projectFiles(
        event.project.sdk,
        event.project.id,
      ),
    ));
    emit(state.copyWith(completed: true));
  }

  Future<void> _onGettingFreshProjectsEvent(
    GettingFreshProjectsEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    emit(state.copyWith(completed: false));
    emit(state.copyWith(projects: fresher.projects));
    emit(state.copyWith(completed: true));
  }

  Future<void> _onGettingFreshVariablesEvent(
    GettingFreshVariablesEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    emit(state.copyWith(completed: false));
    emit(state.copyWith(
      variables: fresher.projectVariables(
        event.project.sdk,
        event.project.id,
      ),
    ));
    emit(state.copyWith(completed: true));
  }

  Future<void> _onFreshingProjectEvent(
    FreshingProjectEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    emit(state.copyWith(completed: false));

    final files = fresher.projectFiles(
      event.project.sdk,
      event.project.id,
    );
    final variables = fresher.projectVariables(
      event.project.sdk,
      event.project.id,
    );
    for (final file in files) {
      final content = file.value(variables);
      final l = [
        ...state.filesWithStatus,
        FileWithStatus(
          file: file,
          status: UpdatedStatus.overwrited,
        ),
      ];
      emit(state.copyWith(filesWithStatus: l));
    }

    emit(state.copyWith(completed: true));
  }

  Future<void> _onGettingSdksEvent(
    GettingSdksEvent event,
    Emitter<FreshAllState> emit,
  ) async {
    emit(state.copyWith(completed: false));
    emit(state.copyWith(sdks: fresher.sdks));
    emit(state.copyWith(completed: true));
  }
}
