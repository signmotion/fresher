import 'dart:io';

import 'package:fresher/fresher.dart';
import 'package:fresher/src/tools/fresh_all/bloc.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// ! See CLI tests in `test/bin/fresher_test.dart`.
/// ! See Fresher tests in `test/fresher_test.dart`.
Future<void> main() async {
  final source = p.join('test', 'data', 'all_projects');
  final options = FresherOptions()
    ..sourceDirectory = Directory(source)
    ..leaveSpaces = false;

  group('GettingSdksEvent', () {
    final bloc = FreshAllBloc(options);

    test('check', () async {
      bloc.add(const GettingSdksEvent());
      await bloc.allCompleted();

      expect(bloc.state.sdks, const ['dart', 'flutter']);
    });
  });

  group('GettingFreshProjectsEvent', () {
    final bloc = FreshAllBloc(options);

    test('check', () async {
      bloc.add(const GettingFreshProjectsEvent());
      await bloc.allCompleted();

      expect(
        bloc.state.projects.map((p) => '$p').toList(),
        const ['dart:id_gen', 'flutter:title_widget'],
      );
    });
  });

  group('FreshingProjectFilesEvent', () {
    final bloc = FreshAllBloc(options);

    test('check', () async {
      const project = FreshProject(sdk: 'dart', id: 'id_gen');
      bloc.add(const FreshingProjectFilesEvent(
        pathPrefix: '_output',
        project: project,
      ));
      await bloc.allCompleted();

      final fs = bloc.state.filesWithStatus;
      expect(fs.keys.toList(), const ['dart:id_gen']);
      expect(fs.values.first.length, 21);
    });
  });

  /* Doesn't work: interrupts when Process.start().
  Use `bin/fresher_test.dart`, `check upgraded dependencies`.
  group('UpgradingProjectEvent', () {
    final source = p.join('test', 'data');
    final options = FresherOptions()
      ..sourceDirectory = Directory(source)
      ..leaveSpaces = false;
    final bloc = FreshAllBloc(options);

    test('check', () async {
      const project = FreshProject(sdk: '', id: 'pubspec_yaml_only');
      bloc.add(UpgradingProjectEvent(
        pathPrefix: source.npath,
        project: project,
      ));
      await bloc.allCompleted();

      expect(bloc.state.ok, isTrue, reason: '${bloc.state.error}');

      final fs = bloc.state.packagesWithStatus;
      expect(fs.keys.toList(), const [':id_gen']);
      expect(fs.values.first.length, 4);
    });
  });
  */
}
