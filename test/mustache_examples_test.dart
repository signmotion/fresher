import 'package:fresher/fresher.dart';
import 'package:mustache_template/mustache.dart';
import 'package:test/test.dart';

/// Use [EmojiTemplate] if a source has emojies.
void main() {
  test('inner value', () {
    final t = Template('{{author.name}}');
    final r = t.renderString({
      'author': {
        'name': 'John C. Wright',
      },
    });
    expect(r, 'John C. Wright');
  });

  group('welcome, project_title', () {
    test('one line', () {
      final t = Template('The package {{project_title}} is open-source');
      final r = t.renderString({'project_title': 'IdGen'});
      expect(r, 'The package IdGen is open-source');
    });

    test('one line, md, bold', () {
      final t = Template('The package **{{project_title}}** is open-source');
      final r = t.renderString({'project_title': 'IdGen'});
      expect(r, 'The package **IdGen** is open-source');
    });

    test('multiline, md, bold', () {
      final t = Template('''
## Welcome

The package **{{project_title}}** is open-source
''');
      final r = t.renderString({'project_title': 'IdGen'});
      expect(r, contains('**IdGen**'));
    });

    test('multiline, md, bold, emojies', () {
      final t = EmojiTemplate('''
## 🙋‍♀️🙋‍♂️Welcome

The package **{{project_title}}** is open-source
''');
      final r = t.renderString({'project_title': 'IdGen'});
      expect(r, contains('**IdGen**'));
    });
  });
}
