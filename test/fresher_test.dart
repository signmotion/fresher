import 'package:collection/collection.dart';
import 'package:fresher/fresher.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:wfile/wfile.dart';

void main() {
  final source = p.join('test', 'data', 'all_projects');
  final f = Fresher(source);

  group('scope', () {
    test('$source/$fresherPrefix/$fresherFile', () {
      final path = p.join(source, fresherPrefix, fresherFile);
      expect(f.scope(path), isEmpty);
    });

    test('$source/$fresherPrefix/+README.md/$fresherFile', () {
      final path = p.join(source, fresherPrefix, '+README.md', fresherFile);
      expect(f.scope(path), 'readme');
    });

    test('$source/$fresherPrefix/+README.md/whats_new_section.md', () {
      final path =
          p.join(source, fresherPrefix, '+README.md', 'whats_new_section.md');
      expect(f.scope(path), 'readme');
    });
  });

  group('sdks & projects', () {
    test('sdks', () {
      expect(f.sdks, equals(['dart', 'flutter']));
    });

    test('projects', () {
      expect(
        f.projects.map((p) => '$p').toList(),
        equals(['dart:id_gen', 'flutter:title_widget']),
      );
    });
  });

  group('files', () {
    test('files for root, check names', () {
      final r = f.rootFiles().map((file) => file.key).toList();
      expect(
        r,
        containsAll([
          '.github/ISSUE_TEMPLATE/feature_request.md',
          '.vscode/settings.default.json',
          '.gitignore',
          '.markdownlint.json',
          'LICENSE',
          'README.md',
        ]),
      );
      expect(r, isNot(contains('+README.md')));
      expect(r, isNot(contains('+README.md/welcome_section.md')));
      expect(r, isNot(contains('+.yaml')));
    });

    test('files for sdk, check names', () {
      const sdk = 'dart';
      final r = f.sdkFiles(sdk).map((file) => file.key).toList();
      expect(
        r,
        containsAll([
          // all from the test `files for root`
          '.github/ISSUE_TEMPLATE/feature_request.md',
          '.vscode/settings.default.json',
          '.gitignore',
          '.markdownlint.json',
          'LICENSE',
          'README.md',
          // plus own files
          '.github/workflows/dart-ci.yml',
          'analysis_options.yaml',
          // plus replaced files
          // see the test below with `check links`
        ]),
      );
      expect(r, isNot(contains('+README.md')));
      expect(r, isNot(contains('+README.md/welcome_section.md')));
      expect(r, isNot(contains('+.yaml')));
    });

    test('files for sdk, check links (paths to files)', () {
      const sdk = 'dart';
      final r = f.sdkFiles(sdk).map((file) => file.file.npath).toList();
      final prefixSource = p.join(source, fresherPrefix).normalizedPath;
      final prefixSdk = p.join(source, sdk, fresherPrefix).normalizedPath;
      expect(
        r,
        containsAll([
          // all from the test `files for root`
          '$prefixSource/.github/ISSUE_TEMPLATE/feature_request.md',
          '$prefixSource/.vscode/settings.default.json',
          //'$prefixSource/.gitignore', - replaced to `prefixSdk`, see below
          '$prefixSource/.markdownlint.json',
          '$prefixSource/LICENSE',
          '$prefixSource/README.md',
          // plus own files
          '$prefixSdk/.github/workflows/dart-ci.yml',
          '$prefixSdk/analysis_options.yaml',
          // plus replaced files
          '$prefixSdk/.gitignore',
        ]),
      );
      expect(r, isNot(contains('$prefixSource/.gitignore')));
    });

    test('files for project, check names', () {
      const sdk = 'dart';
      const projectId = 'id_gen';
      final r = f.projectFiles(sdk, projectId).map((file) => file.key).toList();
      expect(
        r,
        containsAll([
          // all from the test `files for sdk`
          '.github/ISSUE_TEMPLATE/feature_request.md',
          '.github/workflows/dart-ci.yml',
          '.vscode/settings.default.json',
          '.gitignore',
          '.markdownlint.json',
          'LICENSE',
          'README.md',
          'analysis_options.yaml',
          // plus own files
          'images/cover.webp',
          // plus replaced files
          // have not
        ]),
      );
      expect(r, isNot(contains('+README.md')));
      expect(r, isNot(contains('+README.md/description.md')));
      expect(r, isNot(contains('+README.md/welcome_section.md')));
      expect(r, isNot(contains('+.yaml')));
    });
  });

  group('variables', () {
    test('variables for root, check names', () {
      final r = f.rootVariables().map((v) => v.fullNames.first).toList();
      expect(
        r,
        equals([
          '.current_year',
          '.owner_full_name',
          '.owner_id',
          '.owner_website',
          '.publisher_id',
          'readme.created_with',
          'readme.todo_section',
          'readme.welcome_section',
          'readme.whats_new_section',
        ]),
      );
    });

    test('variables for root, check values', () {
      final r = f.rootVariables().map((v) => v.rawValue).toList();
      expect(
        r,
        containsAll([
          '2024',
          'Andrii Syrokomskyi',
          'signmotion',
          'https://syrokomskyi.com',
          'syrokomskyi.com',
          'Created [with ❤️](https://syrokomskyi.com)',
        ]),
      );
    });

    test('variables for sdk, check names', () {
      const sdk = 'dart';
      final r = f.sdkVariables(sdk).map((v) => v.fullNames.first).toList();
      expect(
        r,
        equals([
          // all from the test `variables for root`
          // plus own variables
          // plus replaced variables
          // see the test below with `check values`
          '.current_year',
          '.owner_full_name',
          '.owner_id',
          '.owner_website',
          '.publisher_id',
          '.workflow_file_name',
          'readme.created_with',
          'readme.todo_section',
          'readme.welcome_section',
          'readme.whats_new_section',
        ]),
      );
    });

    test('variables for sdk, check values', () {
      const sdk = 'dart';
      final r = f.sdkVariables(sdk).map((v) => v.rawValue).toList();
      expect(
        r,
        containsAll([
          // all from the test `variables for root`
          '2024',
          'Andrii Syrokomskyi',
          'signmotion',
          'https://syrokomskyi.com',
          'Created [with ❤️](https://syrokomskyi.com)',
          // plus an own variable
          'dart-ci.yml',
          // a replaced variable
          'someone.dart.publisher',
        ]),
      );
    });
  });

  test('variables for project, check names', () {
    const sdk = 'dart';
    const projectId = 'id_gen';
    final r = f
        .projectVariables(sdk, projectId)
        .map((v) => v.fullNames.first)
        .toList();
    expect(
      r,
      equals([
        // all from the test `variables for sdk`
        // plus own variables
        // plus replaced variables
        // see the test below with `check values`
        '.current_year',
        '.owner_full_name',
        '.owner_id',
        '.owner_website',
        '.project_id',
        '.project_title',
        '.project_title_for_readme',
        '.publisher_id',
        '.workflow_file_name',
        'readme.created_with',
        'readme.description',
        'readme.title',
        'readme.todo_list',
        'readme.todo_section',
        'readme.usage_section',
        'readme.welcome_section',
        'readme.whats_new_section',
      ]),
    );
  });

  test('variables for project, check values', () {
    const sdk = 'dart';
    const projectId = 'id_gen';
    final r =
        f.projectVariables(sdk, projectId).map((v) => v.rawValue).toList();
    expect(
      r,
      containsAll([
        // all from the test `variables for sdk`
        'IDs Generators',
        'IdGen',
        '2024',
        'Andrii Syrokomskyi',
        'signmotion',
        'https://syrokomskyi.com',
        'Created [with ❤️](https://syrokomskyi.com)',
        // plus an own variable
        'dart-ci.yml',
        // a replaced variable
        'someone.dart.publisher',
      ]),
    );
  });

  group('templated variables', () {
    const sdk = 'dart';
    const projectId = 'id_gen';

    test('welcome_section', () {
      const name = 'welcome_section';
      final variables = f.projectVariables(sdk, projectId).toList();
      final variable = variables.firstWhereOrNull((v) => v.hasName(name))!;

      // raw value
      final raw = variable.rawValue;
      expect(raw, contains('{{owner_id}}'));
      expect(raw, contains('{{project_id}}'));
      expect(raw, contains('{{project_title}}'));

      // templated value
      final text = variable.value(variables);
      WFile('_output/welcome_section.md').writeAsText(text);
      expect(text, isNot(contains('{{owner_id}}')));
      expect(text, isNot(contains('{{project_id}}')));
      expect(text, isNot(contains('{{project_title}}')));

      // owner_id
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('owner_id'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }

      // project_id
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('project_id'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }

      // project_title
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('project_title'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }
    });
  });

  group('templated files', () {
    const sdk = 'dart';
    const projectId = 'id_gen';

    test('README.md', () {
      const name = 'README.md';
      final files = f.projectFiles(sdk, projectId).toList();
      final file = files.firstWhereOrNull((v) => v.key == name)!;

      // raw value
      final raw = file.rawValue;
      expect(raw, contains('{{project_id}}'));
      expect(raw, contains('{{project_title}}'));
      expect(raw, contains('{{created_with}}'));

      // templated value
      final variables = f.projectVariables(sdk, projectId).toList();
      final text = file.value(variables);
      WFile('_output/README.md').writeAsText(text);
      expect(text, isNot(contains('{{project_id}}')));
      expect(text, isNot(contains('{{project_title}}')));
      expect(text, isNot(contains('{{project_with}}')));

      // title
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('title'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }

      // created_with
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('created_with'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }
    });

    test('LICENSE', () {
      const name = 'LICENSE';
      final files = f.projectFiles(sdk, projectId).toList();
      final file = files.firstWhereOrNull((v) => v.key == name)!;

      // raw value
      final raw = file.rawValue;
      expect(raw, contains('{{current_year}}'));
      expect(raw, contains('{{owner_full_name}}'));
      expect(raw, contains('{{owner_website}}'));

      // templated value
      final variables = f.projectVariables(sdk, projectId).toList();
      final text = file.value(variables);
      WFile('_output/LICENSE').writeAsText(text);
      expect(text, isNot(contains('{{current_year}}')));
      expect(text, isNot(contains('{{owner_full_name}}')));
      expect(text, isNot(contains('{{owner_website}}')));

      // current_year
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('current_year'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }

      // owner_full_name
      {
        final v = variables
            .firstWhereOrNull((v) => v.hasName('owner_full_name'))!
            .value(variables);
        expect(v, isNotEmpty);
        expect(text, contains(v));
      }
    });
  });
}
