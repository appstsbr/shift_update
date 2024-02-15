import 'package:shift_flutter/src/services/login_network_dc.dart';
import 'network/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

/// [HttpService] class responsavel pelas requisições https junto ao servidor do shift
/// a class contem metodos que alem de fazer requisições https
/// busca o usuario ja logado no local storage do aparelho
/// fazendo assim que a requisição seja automatica apos a primeira requisição
/// a class implementa um singleton fazendo que nao seja instanciadas novas instancia
/// fazendo assim que nao haja repetição de instancia da class na memoria.

class HttpService {
  //instancia para construtor privado da class [HttpService]
  static final HttpService _singleton = HttpService._internal();
  //instancia para a class responsavel pela requisição segura com o DC
  static final ControllerDataDc _controllerDataDc = ControllerDataDc();
  //construtor responsavel por chamar a instancia ja referenciada na memoria
  factory HttpService() {
    return _singleton;
  }
  //construtor privado da class
  HttpService._internal();
  //url para requisição com o servidor
  final authorizationEndpoint =
      Uri.parse('${NetworkUtils.urlBase}${NetworkUtils.tokenEndpoint}');
  //variavel responsavel pelo SecureStorage
  final _secureStorage = FlutterSecureStorage();

  /// Recupera o token no dispositivo, caso o dispositivo ja tenha se logado
  /// caso contrario retorna um valor vazio
  Future<String> _getMobileToken() async {
    return await _secureStorage.read(key: NetworkUtils.storageKeyMobileToken) ??
        '';
  }

  //metodo responsavel por guardar o token na requisição de login, na memoria do aparelho
  Future<bool> setSharedToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('token', value);
  }

  // Salva o token no dispositivo
  Future<void> _setMobileToken(String token) async {
    return await _secureStorage.write(
        key: NetworkUtils.storageKeyMobileToken, value: token);
  }

  // Verifica se tem um token no dispositivo
  // retorna o cliente
  Future getClient() async {
    var _mobileToken = await _getMobileToken();

    if (_mobileToken.isEmpty) {
      throw "Couldn't get user";
    } else {
      var client =
          oauth2.Client(oauth2.Credentials.fromJson(jsonDecode(_mobileToken)));

      return client;
    }
  }

  /// O metodo [setClient] recebe como parametro [username] e [password]
  /// para fazer uma requisição ao servidor DC o mesmo retornando true ou false
  /// Utilizando login, senha, client_id e client_secret
  /// acessa a rota de auth para recuperar as credencias no servidor
  /// e armazenar as mesmas
  Future<int> setClient(username, password) async {
    return await _controllerDataDc
        .hitApi(username, password)
        .then((value) async {
      print("USUARIO LOGADO NO DC: $value");
      if (value) {
        try {
          var client = await oauth2.resourceOwnerPasswordGrant(
            authorizationEndpoint,
            username,
            password,
            identifier: NetworkUtils.clientIdentifier,
            secret: NetworkUtils.clientSecret,
          );
          await _secureStorage.write(key: "user", value: username);
          await _setMobileToken(jsonEncode(client.credentials.toJson()));
          return 0;
        } on FormatException catch (e1) {
          return 2;
        } on oauth2.AuthorizationException catch (e2) {
          print(
              "\n\n************* - NAO AUTORIZADO NO BANCO SERVIDOR ***************\n\n");
          return 1;
        } catch (e3) {
          print(e3);
          return 3;
        }
      } else {
        return 1;
      }
    });
  }

  //verifica se a um usuario logado no aparelho, buscando assim no local storage
  Future<String> getUser() async {
    String? u = await _secureStorage.read(key: "user");
    return u == null ? "" : u;
  }

  // Armazena as ultimas credenciais e fecha o cliente
  void closeClient(client) async {
    await _setMobileToken(jsonEncode(client.credentials.toJson()));

    client.close();
  }

  // Verifica se tem um token valido no dispositivo
  Future<bool> ensureLoggedIn() async {
    try {
      await getClient();
      return true;
    } catch (error) {
      return false;
    }
  }

  // Remove as credenciais do dispositivo
  Future<void> logout() async {
    if (await ensureLoggedIn()) {
      await _secureStorage.delete(key: NetworkUtils.storageKeyMobileToken);
    }
  }
}
