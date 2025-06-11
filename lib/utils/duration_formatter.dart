class DurationFormatter {
  static String format(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0 && seconds > 0) {
      return '${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else if (seconds > 0) {
      return '${seconds}s';
    } else {
      return '0s';
    }
  }

  static String formatTimeControl(Duration time, Duration increment) {
    final timeStr = format(time);
    final incStr = format(increment);
    return increment.inSeconds > 0 ? '$timeStr + $incStr' : timeStr;
  }
}
