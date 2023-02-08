import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

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

Future<DateTime> getNtpTime() async {
  DateTime _myTime;
  DateTime _ntpTime;

  /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
  _myTime = DateTime.now();

  /// Or get NTP offset (in milliseconds) and add it yourself
  final int offset = await NTP.getNtpOffset(
      localTime: _myTime, lookUpAddress: 'time.google.com');

  _ntpTime = _myTime.add(Duration(milliseconds: offset));

  // print('My time: $_myTime');
  // print('NTP time: $_ntpTime');
  // print('Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');
  // print('utc: ${_myTime.toUtc()}');
  // print('utc: ${_ntpTime.toUtc()}');

  return _ntpTime;
}

Future<int> calculateDifference(DateTime date) async {
  DateTime now = await getNtpTime();
  return DateTime(date.year, date.month, date.day)
      .difference(
          DateTime(now.toUtc().year, now.toUtc().month, now.toUtc().day))
      .inDays;
}

Future<int> WithoutUTC(DateTime date) async {
  DateTime now = await getNtpTime();
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
