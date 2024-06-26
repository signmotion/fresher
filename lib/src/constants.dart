part of '../fresher.dart';

/// The start of filename for detect a [Fresher] file or directory.
const fresherPrefix = '+';

/// The file with variables and rules.
const fresherFile = '$fresherPrefix.yaml';

/// The folder for output some data by processing projects.
/// For example, a `git log`.
/// See [FresherFileSystemEntityExt.isInFresherOutputFolder].
const fresherOutputFolder = '_output';

/// Count of git log lines when output result.
const fresherMaxGitLogLines = 30;

/// The start of filename for detect a service file or directory.
/// For example, a folder of VSCode or `.gitignore` file.
/// See [FresherFileSystemEntityExt.isServiceEntity].
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
