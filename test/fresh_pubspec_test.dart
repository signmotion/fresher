import 'package:fresher/fresher.dart';
import 'package:test/test.dart';

void main() {
  group('correct data', () {
    test('pubspec.lock + pubspec.yaml', () async {
      final pubspec = FreshPubspec('test/data/pubspec_lock_and_yaml');
      final r = await pubspec.outdatedAsJson;
      expect(r.length, 0, reason: '$r');
    });
  }, tags: ['current']);
}
