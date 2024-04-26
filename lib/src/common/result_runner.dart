part of 'bloc.dart';

/// Result after completed a run.
/// See [Runner].
abstract class ResultRunner {
  ResultRunner({this.error});

  Exception? error;

  bool get ok => error == null;

  bool get hasError => !ok;
}
