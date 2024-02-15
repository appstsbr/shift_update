import 'package:shift_flutter/src/helpers/date_helper.dart';

/// class generica [FormatString] é responsavel pela formatação de strings

class FormatString {
  static List<String> date(String date) {
    List<String> s = date.split(" ");
    //List<String> s2 = s[0].split("/");
    //s[0] = "${s2[2]}/${s2[1]}/${s2[0]}";
    return s;
  }

  static String dateAndTime(String date, {bool timeFirst: false}) {
    var d = DateTime.parse(date);
    return DateHelper.defaultFormat(d);
  }

  static String capitalizeText(String text) {
    if (text.length > 0) {
      return ('${text[0].toUpperCase()}${text.substring(1)}');
    }
    return text;
  }

  static String fixTextLength(String text, int maxSize) {
    String newString;
    if (text.length > maxSize) {
      newString = text.substring(0, maxSize);
      newString = newString + '...';
    } else {
      newString = text;
    }

    return newString;
  }
}
