// ignore_for_file: avoid_print

part of 'bloc.dart';

abstract class AFreshAllEvent extends AEvent {
  const AFreshAllEvent();
}

class GettingSdksEvent extends AFreshAllEvent {
  const GettingSdksEvent();
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

class FreshingProjectFilesEvent extends AFreshAllEvent {
  const FreshingProjectFilesEvent({
    required this.project,
    this.output = defaultOutput,
  });

  final FreshProject project;
  final void Function(String s) output;

  static void defaultOutput(String s) => print(s);
  //static Future<void> defaultOutput(String s) async => stdout..write(s);

  @override
  List<Object?> get props => [...super.props, project, output];
}

class UpgradingProjectEvent extends AFreshAllEvent {
  const UpgradingProjectEvent({
    required this.project,
    this.output = defaultOutput,
  });

  final FreshProject project;
  final void Function(String s) output;

  static void defaultOutput(String s) => print(s);
  //static Future<void> defaultOutput(String s) async => stdout..write(s);

  @override
  List<Object?> get props => [...super.props, project, output];
}

class OutputEvent extends AFreshAllEvent {
  const OutputEvent(this.output, this.s);

  final void Function(String s) output;
  final String s;

  @override
  List<Object?> get props => [...super.props, output, s];
}
