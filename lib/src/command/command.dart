part of '_.dart';

abstract class ACommand<R, O> extends Equatable {
  const ACommand(this.options);

  final O options;

  O get o => options;

  Future<R> run();

  @override
  List<Object?> get props => [];
}
