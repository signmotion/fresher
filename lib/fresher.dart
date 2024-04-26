library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:equatable/equatable.dart';
import 'package:json_dart/json_dart.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:recase/recase.dart';
import 'package:wfile/wfile.dart';
import 'package:yaml/yaml.dart';

import 'src/util/log.dart';

part 'src/extensions/enum.dart';
part 'src/extensions/file_system_entity.dart';
part 'src/extensions/pause.dart';
part 'src/extensions/string.dart';

part 'src/constants.dart';
part 'src/emoji_template.dart';
part 'src/file_conflict_resolution.dart';
part 'src/fresh_file.dart';
part 'src/fresh_package.dart';
part 'src/fresh_project.dart';
part 'src/fresh_pubspec.dart';
part 'src/fresh_variable.dart';
part 'src/fresher.dart';
part 'src/fresher_options.dart';
part 'src/pubspec.dart';
