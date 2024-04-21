import 'dart:io';

import 'package:fresher/fresher.dart';
import 'package:fresher/src/tools/fresh_all/bloc.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// ! See CLI tests in `test/bin/fresher_test.dart`.
/// ! See Fresher tests in `test/fresher_test.dart`.
void main() {
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
      bloc.add(const FreshingProjectFilesEvent(project: project));
      await bloc.allCompleted();

      final fs = bloc.state.filesWithStatus;
      expect(fs.keys.toList(), const ['dart:id_gen']);
      expect(fs.values.first.length, 21);
    });
  }, tags: ['current']);
}
