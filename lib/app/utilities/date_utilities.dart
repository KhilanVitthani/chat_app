import 'package:intl/intl.dart';

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

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now().toUtc();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

int WithoutUTC(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

DateTime getDateFromStringFromUtc(String dateString, {String? formatter}) {
  const String kMainSourceFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
  if (formatter == null) {
    formatter = kMainSourceFormat;
  }
  return DateFormat(formatter).parse(dateString, true);
}
