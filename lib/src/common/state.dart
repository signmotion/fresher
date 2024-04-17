part of 'bloc.dart';

abstract class AState extends Equatable {
  const AState({
    required this.source,
    this.completed = false,
  });

  final Directory source;

  // services
  final bool completed;

  @override
  List<Object?> get props => [source, completed];
}
