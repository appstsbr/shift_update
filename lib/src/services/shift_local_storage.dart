import 'package:shared_preferences/shared_preferences.dart';

/// Classe [ShiftLocalStorage] utiliza o SharedPreferences para
/// Encapsula no iOS e no Android, fornecendo um armazenamento
/// persistente para dados simples.

class ShiftLocalStorage {
  //varivel que recebe a instancia do [SharedPreferences]
  final prefs = SharedPreferences.getInstance();

  ///metodo responsavel por salvar os dados no aparelho celular
  /// setando assim grupo e mensagem passada
  void saveToStorage(String groupId, String messageId) {
    prefs.then((p) {
      p.setString(groupId, messageId);
    });
  }

  //metodo responsavel por buscar os dados do usuario pela sua chave
  Future<String> getFromStorage(String key) async {
    return await prefs.then((p) {
      String? data = p.getString(key);
      return data!;
    });
  }

  // metodo resposavel pela comparação de ids, ids que são classificados em Grupo ou Chat
  bool compareMessageIds(SharedPreferences p, String groupId, String msgId) {
    if (p.getString(groupId) == msgId)
      return true;
    else
      return false;
  }
}
