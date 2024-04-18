part of 'bloc.dart';

class FreshAllResultRunner extends ResultRunner {
  const FreshAllResultRunner({
    required super.ok,
    super.error,
    required this.state,
  });

  final FreshAllState state;

  @override
  String toString() {
    var r = '';

    for (final e in state.filesWithStatus.entries) {
      final projectKey = e.key;
      r += '\n$projectKey\n';
      final table = Table(
        header: ['Status'.whiteBright, 'File'.whiteBright],
        columnAlignment: [HorizontalAlign.right, HorizontalAlign.left],
      );
      // group and sort
      final sorted = List.of(e.value, growable: false)..sort();
      for (final fs in sorted) {
        table.add([fs.status.coloredName, fs.file.key]);
      }
      r += '$table';
    }

    return r;
  }
}
