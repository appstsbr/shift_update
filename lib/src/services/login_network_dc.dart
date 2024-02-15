// ignore_for_file: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';

/// A class [ControllerDataDc] e class responsavel por fazer a
/// requisição post para o web service do DC dos sistemas internos
/// o servidor ira retornar true ou false para a requisição
/// verificando assim se o usuario esta instanciado a empresa.
class ControllerDataDc {
  static ControllerDataDc? _instance;
  ControllerDataDc._();

  factory ControllerDataDc() {
    return _instance == null ? ControllerDataDc._() : _instance!;
  }

  bool valor = false;
  static const String endpoint =
      "https://tssistemasinternos.t-systems.com.br/ConsultaADWebService.asmx?wsdl";

  Future<bool> hitApi(String username, String pwd) async {
    var requestBody = '''<?xml version="1.0" encoding="utf-8"?>
            <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
              <soap:Body>
                <AuthenticateDB xmlns="http://tempuri.org/">
                  <username>$username</username>
                  <pwd>$pwd</pwd>
                </AuthenticateDB>
              </soap:Body>
            </soap:Envelope>''';

    http.Response response = await http.post(
      Uri.parse(
          'https://tssistemasinternos.t-systems.com.br/ConsultaADWebService.asmx?wsdl'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/AuthenticateDB',
        'Host': 'tssistemasinternos.t-systems.com.br',
        'Content-Length': requestBody.length.toString(),
      },
      body: utf8.encode(requestBody),
    );
    return response.body.contains("true");
  }
}
