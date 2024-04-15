library;

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:equatable/equatable.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:wfile/wfile.dart';
import 'package:yaml/yaml.dart';

part 'src/extensions/file_system_entity.dart';
part 'src/extensions/string.dart';

part 'src/constants.dart';
part 'src/emoji_template.dart';
part 'src/fresh_file.dart';
part 'src/fresh_variable.dart';
part 'src/fresher.dart';
part 'src/project.dart';
