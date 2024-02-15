import 'package:flutter/widgets.dart';
import 'package:shift_flutter/src/models/user.dart';

/// class [Global] é responsavel por retornar um singleton
/// com atributos como [user] para o usuario logado
/// como [context], [userData], [showPush], auxiliando no context
/// de navegação e uso de dados de usuarios.
class Global {
  static Global? _instance;

  Global._() {}

  factory Global() {
    if (_instance == null) {
      print("instance null");
      _instance = Global._();
    }
    return _instance!;
  }

  late BuildContext context;
  late Map<String, dynamic> userData;
  late User user;
  late bool showPush = true;
}
