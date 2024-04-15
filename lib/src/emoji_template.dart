part of '../fresher.dart';

/// The [Template] from [mustache_template](https://pub.dev/packages/mustache_template).
/// Reason this class: no maintainability. See [PR](https://github.com/jonahwilliams/mustache/pull/6/files).
class EmojiTemplate {
  const EmojiTemplate(
    this.source, {
    this.braces = const ['^', '^'],
  }) : assert(braces.length == 2);

  final String source;

  /// For replace emojies.
  /// See [renderString].
  final List<String> braces;

  /// See [Template.renderString].
  String renderString(dynamic values) {
    var ps = source;
    final matches = emojiRegex().allMatches(source);
    var id = 1;
    final map = {
      for (final m in matches)
        '${braces.first}${id++}${braces.last}': m.group(0)!
    };
    for (final e in map.entries) {
      ps = ps.replaceAll(e.value, e.key);
    }

    final template = Template(ps, htmlEscapeValues: false);
    final r = template.renderString(values);

    var pr = r;
    for (final e in map.entries) {
      pr = pr.replaceAll(e.key, e.value);
    }

    return pr;
  }
}
