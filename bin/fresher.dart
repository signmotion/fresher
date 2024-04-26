// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:fresher/fresher.dart';
import 'package:fresher/tool_fresher.dart';
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

  parser.addFlag(
    'leave-spaces',
    help: 'All spaces at the ends will be preserved.',
  );

  parser.addFlag(
    'no-upgrade',
    help: 'Skip an upgrade dependencies.',
  );

  parser.addFlag(
    'no-git-logs',
    help: 'Skip a fetch git logs.',
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

  final o = ToolOptions()
    ..sourceFolder = results.rest.first
    ..projectIds = (results['projects'] as String?)?.split(',') ?? []
    ..leaveSpaces = results.wasParsed('leave-spaces')
    ..noUpgrade = results.wasParsed('no-upgrade')
    ..noGitLogs = results.wasParsed('no-git-logs');

  final tools = Tool(o);
  final r = await tools.freshAll();
  print('$newLine$r');
}

void printUsageAndExit(ArgParser parser) {
  print('''
Usage:
\tdart bin/fresher.dart [flags] [options] ../path/to/project/bases
${parser.usage}
  ''');
  // exit code `64` indicates a usage error
  exit(64);
}
