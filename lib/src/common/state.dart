part of 'bloc.dart';

abstract class AState extends Equatable {
  const AState({
    this.completed = const {},
  });

  // services
  final Map<String, bool> completed;

  @override
  List<Object?> get props => [completed];
}
