import 'package:flutter/material.dart';
import 'package:shift_flutter/src/lang/Strings.dart';

/// class generica [EventTypeData] é resposnavel pelo retorno de
/// icones personalizados para eventos

class EventTypeData {
  static Icon icon(type, {double? size}) {
    if (size == null) {
      size = 25;
    }
    switch (type) {
      case 1:
        return Icon(
          iconData(type),
          color: color(type),
          size: size,
        );
      case 3:
        return Icon(
          iconData(type),
          color: color(type),
          size: size,
        );
      case 4:
        return Icon(
          iconData(type),
          color: color(type),
          size: size,
        );
      case 5:
        return Icon(
          iconData(type),
          color: color(type),
          size: size,
        );
      default:
        return Icon(
          iconData(type),
          color: color(type),
          size: size,
        );
    }
  }

  static IconData iconData(int type) {
    switch (type) {
      case 1:
        return Icons.add_circle;
      case 3:
        return Icons.info;
      case 4:
        return Icons.info;
      case 5:
        return Icons.check_circle;
      default:
        return Icons.fiber_manual_record;
    }
  }

  static Color color(int type) {
    switch (type) {
      case 1:
        return Color.fromRGBO(250, 81, 63, 1);
      case 3:
        return Color.fromRGBO(250, 219, 86, 1);
      case 4:
        return Color.fromRGBO(241, 196, 15, 1.0);
      case 5:
        return Color.fromRGBO(126, 240, 127, 1);
      case 6:
        return Colors.blueAccent;
      default:
        return Colors.black;
    }
  }

  static String text(int type) {
    Strings strings = Strings();
    String desc = strings.eventScreen.get("event_" + type.toString());
    if (desc != "")
      return desc;
    else
      return strings.eventScreen.get("event_other");

    // switch (type) {
    //   case 1:
    //     return "Aberto";
    //   case 3:
    //     return "Atualização";
    //   case 4:
    //     return "Ticket alterado";
    //   case 5:
    //     return "Concluído";
    //   default:
    //     return "Outro";
    // }
  }
}
