import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../fresher.dart';

part 'events.dart';
part 'result_runner.dart';
part 'runner.dart';
part 'state.dart';

abstract class ABloc<E extends AEvent, S extends AState> extends Bloc<E, S> {
  ABloc(super.initState);

  /// Wait until a process with [key] was finished.
  Future<void> completed(String key) async {
    while (!(state.completed[key] ?? false)) {
      await 200.pauseInMs;
    }
  }

  void unsetCompleted(String key) => setCompleted(key, false);

  void setCompleted(String key, [bool value = true]);

  @mustCallSuper
  @override
  Future<void> close() async {
    await stdout.flush();
    return super.close();
  }
}
