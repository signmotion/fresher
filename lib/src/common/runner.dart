// ignore_for_file: avoid_print

part of '_.dart';

/// Run a process for [sourcePath].
abstract class Runner<R> {
  Runner();

  String get name;

  Future<R> run();

  void pr(String s) => print(s);

  void printis(String s, {bool finalizer = true}) =>
      pr('\n$currentIndent$step) $s'
          '${!finalizer || s.endsWith('.') ? '' : '...'}');

  void printi(String s, {bool finalizer = true}) => pr('$currentIndent$s'
      '${!finalizer || s.endsWith('.') ? '' : '.'}');

  int step = 0;

  void firstStep() {
    step = 1;
    resetCurrentIndent();
  }

  void nextStep() {
    ++step;
    resetCurrentIndent();
  }

  String indent(int n) => (n > 0) ? '  ' * n : '';

  int currentIndentValue = 0;

  String get currentIndent => indent(currentIndentValue);

  void resetCurrentIndent() => currentIndentValue = 0;

  void increaseCurrentIndent() => ++currentIndentValue;

  void decreaseCurrentIndent() => --currentIndentValue;
}
