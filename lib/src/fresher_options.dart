part of '../fresher.dart';

class FresherOptions {
  Directory? sourceDirectory;
  String get sourcePath => sourceDirectory!.path;

  /// Project IDs to update.
  /// If empty, then will update all projects.
  List<String> filter = [];

  /// Keep all spaces at the ends.
  bool leaveSpaces = false;

  /// Leave destination files without changes.
  bool noChanges = false;

  /// Skip a fetch git logs.
  bool noGitLogs = false;

  /// Skip an upgrading dependencies.
  bool noUpgradeDependencies = false;
}
