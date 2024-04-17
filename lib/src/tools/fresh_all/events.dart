part of 'bloc.dart';

abstract class AFreshAllEvent extends AEvent {
  const AFreshAllEvent();
}

class GettingFreshFilesEvent extends AFreshAllEvent {
  const GettingFreshFilesEvent({required this.project});

  final FreshProject project;

  @override
  List<Object?> get props => [...super.props, project];
}

class GettingFreshProjectsEvent extends AFreshAllEvent {
  const GettingFreshProjectsEvent();
}

class GettingFreshVariablesEvent extends AFreshAllEvent {
  const GettingFreshVariablesEvent({required this.project});

  final FreshProject project;

  @override
  List<Object?> get props => [...super.props, project];
}

class FreshingProjectEvent extends AFreshAllEvent {
  const FreshingProjectEvent({required this.project});

  final FreshProject project;

  @override
  List<Object?> get props => [...super.props, project];
}

class GettingSdksEvent extends AFreshAllEvent {
  const GettingSdksEvent();
}
