part of 'bloc.dart';

abstract class AState extends Equatable {
  const AState({
    required this.source,
    this.completed = const {},
  });

  final Directory source;

  // services
  final Map<String, bool> completed;

  @override
  List<Object?> get props => [source, completed];
}
