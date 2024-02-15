import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/custom_widgets/loading_button.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/screens/main/main_screen.dart';
import 'package:shift_flutter/src/screens/login/animation_login.dart';
import 'package:shift_flutter/src/services/http_service.dart';
import 'package:shift_flutter/src/start.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/shift_api_provider.dart';
import 'package:local_auth/local_auth.dart';

///class [LoginScreen] responsavel pelo input de username e
///password para login, alem de possuir um link
///que mostra ao usuario as politicas de privacidade da t-systems

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  late LoginAnimations anim;

  _LoginScreenState();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _state;
  var httpService = new HttpService();
  var shiftProvider = new ShiftApiProvider();
  var _isLogged;

  final passwordFocus = FocusNode();
  final emailFocus = FocusNode();

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  Strings strings = Strings();
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 4000));
    anim = new LoginAnimations(control: animController);
    _state = LoadingButton.init;
    animController.forward();

    _isLogged = false;
    httpService.getUser().then((u) {
      userController.text = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogged)
      return MainScreen();
    else
      return loginScreen();
  }

  Widget loginScreen() {
    return AnimatedBuilder(
      animation: animController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          key: _scaffoldKey,
          body: Center(
              child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/Shift-transparente.png"),
                    color: anim.logoColor.value,
                    width: anim.logoSize.value,
                    height: anim.logoSize.value,
                  ),
                  Container(
                    width: anim.formWidth.value,
                    height: anim.formHeight.value,
                    child: fields(),
                  ),
                  LoadingButton(
                      width: anim.buttonWidth.value,
                      height: anim.buttonHeight.value,
                      textColor: Colors.white,
                      color: CustomTheme.shift().primaryColor,
                      child: Center(
                          child: Text(
                        strings.loginScreen.get("login"),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: login,
                      state: _state),
                  Transform.scale(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: _privacyPolicy,
                        child: Text(
                          strings.loginScreen.get("privacypolicy"),
                          style: TextStyle(
                              color: CustomTheme.shift().primaryColor),
                        ),
                      ),
                    ),
                    scale: anim.scale.value,
                  ),
                ],
              ),
            ),
          )),
          bottomNavigationBar: Container(
            child: Padding(
              child: Text('Shift',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: anim.shiftSize.value,
                      color: anim.logoColor.value,
                      fontFamily: "shift")),
              padding: EdgeInsets.all(anim.shiftSize.value),
            ),
          ),
        );
      },
    );
  }

  Widget fields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: userController,
              textAlign: TextAlign.center,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                emailFocus.unfocus();
                FocusScope.of(context).requestFocus(passwordFocus);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return strings.loginScreen.get("validation_user");
                }
              },
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(226, 0, 116, 1), width: 1.0),
                      borderRadius: BorderRadius.circular(30.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: strings.loginScreen.get("form_user"),
                  labelStyle: TextStyle(color: Colors.black))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: passwordController,
            focusNode: passwordFocus,
            textInputAction: TextInputAction.go,
            textAlign: TextAlign.center,
            validator: (value) {
              if (value!.isEmpty) {
                return strings.loginScreen.get("validation_pass");
              }
            },
            onFieldSubmitted: (x) {
              login();
            },
            obscureText: true,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(226, 0, 116, 1), width: 1.0),
                  borderRadius: BorderRadius.circular(30.0)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              focusColor: Colors.red,
              hintText: strings.loginScreen.get("form_pass"),
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  void alert(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color.fromRGBO(248, 14, 70, 1),
          content: Container(height: 20, child: Center(child: Text(text)))),
    );
  }

  void login() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_formKey.currentState!.validate() && _state != LoadingButton.load) {
      setState(() {
        _state = LoadingButton.load;
      });
      int response = await httpService.setClient(
          userController.text, passwordController.text);
      passwordController.clear();
      switch (response) {
        case 0:
          setState(() {
            NavHelper.pushReplacement(context, Start());
            _isLogged = true;
          });
          break;
        case 1:
          alert(strings.errors.get("error_login"));
          break;
        case 2:
          alert(strings.errors.get("error_server"));
          break;
        default:
          alert(strings.errors.get("error_unknow"));
      }
      setState(() {
        _state = LoadingButton.init;
      });
    }
  }

  void _privacyPolicy() async {
    const url = 'https://shift.t-systems.com.br/privacy';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Erro ao Carregar';
    }
  }
}
