import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:wfile/wfile.dart';

import '../../fresher.dart';
import '../tool/fresh_all/_.dart';
import '../util/log.dart';

part 'command.dart';
part 'fresh_project_files.dart';
part 'get_fresh_projects.dart';
part 'get_sdks.dart';
part 'git_log.dart';
part 'upgrade_project.dart';
