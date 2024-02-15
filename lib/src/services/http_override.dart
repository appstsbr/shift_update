import 'dart:io';

/// A class [MyHttpOverrides] e a class responsavel por fazer uma sobre-escrita
/// nos metodos de requisição https devido o cerficiado enviado na requisição
/// fazendo assim uma comparação de host, verificando assim se o host de envio
/// e o mesmo da t-systems
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) {
        if (host == 'shift.t-systems.com.br') {
          return true;
        }
        return false;
      };
  }
}
