part of '_.dart';

abstract class ACommand<R, O> extends Equatable {
  const ACommand(
    this.options, {
    this.output = defaultOutput,
  });

  final O options;

  O get o => options;

  final void Function(String s) output;

  Future<R> run();

  // ignore: avoid_print
  static void defaultOutput(String s) => print(s);

  @override
  List<Object?> get props => [];
}
