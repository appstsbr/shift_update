import 'package:intl/intl.dart';

/// a class [DateHelper] é uma class generica responsavel
/// pela formatação de datas
class DateHelper {
  static String defaultFormat(DateTime dt) {
    return DateFormat("HH:mm - dd/MM/y").format(dt);
  }

  static String defaultFormatNoTime(DateTime dt) {
    return DateFormat("dd/MM/y").format(dt);
  }

  static String defaultFormatNoDate(DateTime dt) {
    return DateFormat("HH:mm").format(dt);
  }

  static int daysBetween(DateTime beginDate, DateTime endDate) {
    DateTime d1 = DateTime(beginDate.year, beginDate.month, beginDate.day);
    DateTime d2 = DateTime(endDate.year, endDate.month, endDate.day);
    return d2.difference(d1).inDays;
  }

  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static String chat(DateTime dt) {
    DateTime now = DateTime.now();
    dt = dt.add(Duration(hours: -3));
    if (now.day != dt.day)
      return defaultFormatNoTime(dt);
    else
      return defaultFormatNoDate(dt);
  }
}
