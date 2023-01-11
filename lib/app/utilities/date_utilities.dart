String formatTime(int second) {
  var hour = (second / 3600).floor();
  var minutes = ((second - hour * 3600) / 60).floor();
  var seconds = (second - hour * 3600 - minutes * 60).floor();

  var secondExtraZero = (seconds < 10) ? "0" : "";
  var minuteExtraZero = (minutes < 10) ? "0" : "";
  var hourExtraZero = (hour < 10) ? "0" : "";

  if (hour > 0) {
    return "$hourExtraZero$hour:$minuteExtraZero$minutes:$secondExtraZero$seconds";
  } else {
    return "$minuteExtraZero$minutes:$secondExtraZero$seconds";
  }
}
