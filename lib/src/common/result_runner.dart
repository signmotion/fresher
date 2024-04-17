part of 'bloc.dart';

/// Result after completed a run.
/// See [Runner].
abstract class ResultRunner {
  const ResultRunner({
    required this.ok,
    this.error,
  });

  final bool ok;

  final Exception? error;

  bool get hasError => !ok;
}
