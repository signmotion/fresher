part of '_.dart';

extension FresherPauseExt on int {
  /// Pause in milliseconds.
  Future<void> get pauseInMs =>
      Future<void>.delayed(Duration(milliseconds: this));
}
