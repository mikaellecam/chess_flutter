class DurationFormatter {
  static String format(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (totalSeconds <= 0) {
      return '0:00';
    }
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatTimeControl(Duration time, Duration increment) {
    final timeStr = format(time);
    final incStr = format(increment);
    return increment.inSeconds > 0 ? '$timeStr + $incStr' : timeStr;
  }
}
