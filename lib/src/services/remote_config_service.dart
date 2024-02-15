import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shift_flutter/src/lang/Strings.dart';

/// Class [RemoteConfigService]  é responsavel por fazer requisições para o
/// Firebase para verificar mudanças no layout da aplicação
/// verificando assim uma lang de acordo com o usuario
/// a class utiliza Singleton para instanciar-se na memoria.
class RemoteConfigService {
  static RemoteConfigService? _instance;

  RemoteConfigService._() {}

  factory RemoteConfigService() {
    if (_instance == null) {
      _instance = RemoteConfigService._();
    }
    return _instance!;
  }
  //Metodo responsavel pelas requisições ao firebase, buscando assim o lang
  Future<void> init() async {
    final Strings strings = Strings();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 5),
      ),
    );

    await remoteConfig.fetchAndActivate().then((value) {
      strings.init(map: jsonDecode(remoteConfig.getString('lang')));
    });
  }
}
