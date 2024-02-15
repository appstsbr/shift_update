import 'package:flutter/material.dart';

/// class [NavHelper] é uma class generica responsavel
/// pelo gerenciamento de navegação entre telas
class NavHelper {
  static Future<dynamic> push(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static void pop(BuildContext context, {dynamic returnValue}) {
    Navigator.pop(context, returnValue);
  }

  static Future<dynamic> pushReplacement(BuildContext context, Widget screen) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static toRoot(BuildContext context) {
    Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }
}
