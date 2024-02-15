import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/custom_widgets/loading_button.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/main/main_screen.dart';

/// class [PasswordReset] responsavel por exibir um showDialog
/// para troca de senha
class PasswordReset extends StatefulWidget {
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  late int _state;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cpass;
  late TextEditingController _cpassConfirm;
  ShiftApiProvider providers = new ShiftApiProvider();
  Strings strings = Strings();
  @override
  void initState() {
    super.initState();
    _state = LoadingButton.init;
    _cpass = new TextEditingController();
    _cpassConfirm = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      title: Text(strings.profileScreen.get("change_pass"),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomTheme.shift().primaryColor)),
      content: Container(
        height: 180,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _cpass,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty)
                    return strings.profileScreen
                        .get("validation_new_pass_empty");
                  else if (value.length < 6)
                    return strings.profileScreen
                        .get("validation_new_pass_length");
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red)),
                  labelText: strings.profileScreen.get("form_new_pass"),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              TextFormField(
                controller: _cpassConfirm,
                validator: (value) {
                  if (value!.isEmpty)
                    return strings.profileScreen
                        .get("validation_new_pass_confirm_empty");
                  else if (value != _cpass.text)
                    return strings.profileScreen
                        .get("validation_new_pass_confirm_equals");
                },
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red)),
                  labelText: strings.profileScreen.get("form_new_pass_confirm"),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        LoadingButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          state: _state,
          onPressed: _change,
          width: 150,
          height: 50,
          textColor: CustomTheme.shift().primaryColor,
          color: Colors.white,
          child: Center(
              child: Text(
            strings.profileScreen.get("change_pass"),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ],
    );
  }

  void _change() {
    if (_formKey.currentState!.validate() && _state != LoadingButton.load) {
      setState(() {
        _state = LoadingButton.load;
      });
      providers.changePassword(_cpass.text).then((s) {
        if (s == 200) {
          MainScreen.alert(strings.profileScreen.get("message_change_pass"),
              Colors.white, Colors.green);
          Navigator.of(context).pop();
        } else
          MainScreen.alert(
              strings.errors.get("error"), Colors.white, Colors.red);
      });
    }
  }
}
