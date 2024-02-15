import 'package:flutter/material.dart';

class CustomTheme {
  static const int magenta_white = 1;
  static ThemeData def = ThemeData();

  static ThemeData shift() {
    CustomTheme().define(magenta_white);
    return def;
  }

  ThemeData magentaWhite() {
    return ThemeData(
        primaryColor: Color.fromRGBO(226, 0, 116, 1),
        primaryColorDark: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(226, 0, 116, 1),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.white,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))));
  }

  void define(int theme) {
    switch (theme) {
      case magenta_white:
        def = magentaWhite();
        break;
      default:
    }
  }
}
