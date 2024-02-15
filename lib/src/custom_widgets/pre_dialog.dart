import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';

/// class [PreDialog] responsavel por dialogs dinamicos
/// para troca de telas ou ações
class PreDialog {
  static void confirm(
      {required context,
      required String title,
      required String description,
      required String cancel,
      required String confirm,
      required onConfirmed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          titleTextStyle: TextStyle(
              color: CustomTheme.shift().primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            description,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            new FlatButton(
              textColor: Colors.black,
              child: new Text(cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
                textColor: CustomTheme.shift().primaryColor,
                child: new Text(confirm),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmed();
                }),
          ],
        );
      },
    );
  }

  static void open({required context, required Widget child}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
