// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:fresher/tools_fresher.dart';
import 'package:json_dart/json_dart.dart';

Future<void> main(List<String> args) async {
  try {
    await run(args);
  } catch (ex) {
    print('\n$ex\n');
    exit(1);
  }
}

Future<void> run(List<String> args) async {
  print('Argumets: ${args.sjsonInLineWithoutWrappers}');
  final parser = ArgParser();

  parser.addOption(
    'projects',
    help: 'Project IDs to update.'
        ' If empty, all known projects will be updated.',
  );

  late final ArgResults results;
  try {
    results = parser.parse(args);
  } catch (_) {
    printUsageAndExit(parser);
  }

  if (results.rest.isEmpty) {
    printUsageAndExit(parser);
  }

  final o = ToolsOptions()
    ..sourceFolder = results.rest.first
    ..projectIds = (results['projects'] as String?)?.split(',') ?? [];

  final tools = Tools(o);
  final r = await tools.freshAll();
  print('$r');
}

void printUsageAndExit(ArgParser parser) {
  print('''
Usage:
\tdart bin/fresher.dart ../path/to/project/source
${parser.usage}
  ''');
  // exit code `64` indicates a usage error
  exit(64);
}
