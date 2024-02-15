import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shift_flutter/firebase_options.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/main/main_screen.dart';
import 'package:shift_flutter/src/services/firebase_auth_service.dart';
import 'package:shift_flutter/src/services/http_service.dart';
import 'package:shift_flutter/src/services/remote_config_service.dart';
import 'CustomTheme.dart';
import 'screens/login/login_screen.dart';

class Start extends StatefulWidget {
  Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  var httpService = new HttpService();
  var shiftProvider = new ShiftApiProvider();
  var status = "";

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    CustomTheme.shift().primaryColor)),
            Container(
              height: 10,
            ),
            Text(status)
          ],
        ),
      ),
    );
  }

  void init() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Initialized default app $app');
    try {
      setState(() {
        status = "Connecting to server";
      });
      //proteger aqui tbm
      await FirebaseAuthService.signIn("apps@t-systems.com.br", "Tsbr1234!");
      print("logou com firebase");
    } catch (e) {
      print("nao foi possivel logar firebase $e");
    }
    getRemoteConfig();
  }

  void getRemoteConfig() {
    setState(() {
      status = "Configurating language";
    });
    RemoteConfigService().init().whenComplete(() {
      loginWithToken();
    });
  }

  void loginWithToken() async {
    setState(() {
      status = "Validating auth ";
    });
    httpService.ensureLoggedIn().then((_hasToken) {
      if (_hasToken) {
        checkToken();
      } else {
        _toLoginScreen();
      }
    }).catchError((e) {
      _toLoginScreen();
    });
  }

  void checkToken() {
    shiftProvider.getTokenStatus().then((statusCode) async {
      switch (statusCode) {
        case 200:
          Global().user = await shiftProvider.getLoggedUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(),
            ),
          );
          break;
        default:
          _toLoginScreen();
      }
    }).catchError((e) {
      _toLoginScreen();
    });
  }

  void _toLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
  }
}
