import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../fresher.dart';

part 'events.dart';
part 'result_runner.dart';
part 'runner.dart';
part 'state.dart';

abstract class ABloc<E extends AEvent, S extends AState> extends Bloc<E, S> {
  ABloc(super.initState);

  // Wait until a process was finished.
  Future<void> get completed async {
    while (!state.completed) {
      await 200.pauseInMs;
    }
  }
}
