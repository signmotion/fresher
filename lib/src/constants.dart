part of '../fresher.dart';

/// The start of filename for detect a [Fresher] file or directory.
const fresherPrefix = '+';

/// The file with variables and rules.
const fresherFile = '$fresherPrefix.yaml';

/// The start of filename for detect a service file or directory.
/// For example, a folder of VSCode or `.gitignore` file.
const servicePrefix = '.';

/// A platform depended line separator.
/// ! Copied from <https://github.com/signmotion/dart_helpers>.
String get newLine => Platform.isWindows
    ? '\r\n'
    : Platform.isMacOS
        ? '\r'
        : Platform.isLinux
            ? '\n'
            : '\n';
