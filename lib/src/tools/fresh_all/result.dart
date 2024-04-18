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
    // group and sort
    final sorted =
        SplayTreeMap<String, List<FileWithStatus>>.from(state.filesWithStatus);

    var r = '';
    for (final e in sorted.entries) {
      r += '\n${e.key}\n';
      final table = Table(
        header: ['Status'.whiteBright, 'File'.whiteBright],
        columnAlignment: [HorizontalAlign.right, HorizontalAlign.left],
      );
      for (final fs in e.value) {
        table.add([fs.status.coloredName, fs.file.key]);
      }
      r += '$table';
    }

    return r;
  }
}
