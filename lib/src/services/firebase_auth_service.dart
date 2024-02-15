import 'package:firebase_auth/firebase_auth.dart';

/// a class [FirebaseAuthService] e resposanvel pela autenticação com o firestore
/// passando assim email e password retornando assim a instancia do firestore para requisições
/// dentro da aplicação

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return await getCurrentUser();
  }

  static Future<void> signOut(String email, String password) async {
    await _auth.signOut();
  }

  static Future getCurrentUser() async {
    return await _auth.currentUser;
  }

  static Future<bool> isLogged() async {
    return await getCurrentUser() != null;
  }

  static Future<String> getToken() async {
    var user = await getCurrentUser();
    var token = await user.getIdToken();
    return token.token;
  }
}
