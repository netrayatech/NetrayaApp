class Helper {
  static String formatTime(Duration duration, {bool alwaysShowHours = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0 || alwaysShowHours) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
