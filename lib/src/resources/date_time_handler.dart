import 'package:intl/intl.dart';

/// class generica [DateTimeHandler] utilizada para formação de horario, usada em eventos
class DateTimeHandler {
  static String getNotificationTimeInterval(DateTime dateTime) {
    String intervalTime;
    final DateTime now = DateTime.now();
    final DateTime notificationTime = dateTime.subtract(new Duration(hours: 0));

    Duration difference = now.difference(notificationTime);

    if (difference.inSeconds > 60) {
      if (difference.inMinutes > 60) {
        if (difference.inHours > 24) {
          if (difference.inDays > 1) {
            intervalTime = difference.inDays.toString() + ' dias';
          } else {
            intervalTime = difference.inDays.toString() + ' dia';
          }
        } else {
          intervalTime = difference.inHours.toString() + ' h';
        }
      } else {
        intervalTime = difference.inMinutes.toString() + ' min';
      }
    } else {
      intervalTime = difference.inSeconds.toString() + ' s';
    }

    return intervalTime;
  }

  static DateTime stringToDate(String dateTime) {
    return DateTime.parse(dateTime);
  }

  static DateTime setTimeZone(DateTime dateTime) {
    return dateTime.toLocal();
  }

  static String dateTimeToString(DateTime dateTime) {
    return new DateFormat("d/M/y H:mm").format(dateTime);
  }

  static String dateTimeToHour(DateTime dateTime) {
    return new DateFormat("H:mm").format(dateTime);
  }

  static DateTime getUtcDateTime(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;

    return DateTime.utc(year, month, day, hour, minute, second);
  }
}
