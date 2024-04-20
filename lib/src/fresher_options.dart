part of '../fresher.dart';

class FresherOptions {
  Directory? sourceDirectory;
  String get sourcePath => sourceDirectory!.path;

  /// Project IDs to update.
  /// If empty, then will update all projects.
  List<String> filter = [];

  /// Keep all spaces at the ends.
  bool leaveSpaces = false;
}
