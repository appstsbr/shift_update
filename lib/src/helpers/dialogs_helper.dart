import 'package:flutter/material.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';

/// class generica [DialogsHelper] responsavel pelo retorno
/// de [showDialog] e [snackBar] para alertas aos usuarios.
class DialogsHelper {
  static void simple(List<Widget> childrens, {Function? onDismiss, context}) {
    showDialog(
        context: context == null ? Global().context : context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: childrens,
            contentPadding: EdgeInsets.all(20),
          );
        }).then((r) {
      if (onDismiss != null) onDismiss();
    });
  }

  static void error({String message = "", Function? onDismiss}) {
    showDialog(
        context: Global().context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Não foi possível finalizar a ação.",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).errorColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text(message),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Text("Fechar"),
                        onPressed: () {
                          NavHelper.pop(context);
                        },
                      )
                    ],
                  )
                ],
              )
            ],
            contentPadding: EdgeInsets.all(20),
          );
        }).then((r) {
      if (onDismiss != null) onDismiss();
    });
  }

  static void confirm(BuildContext context,
      {String message = "",
      String accept: "Continue",
      String reject: "Cancel",
      Function? onReject,
      Function? onAccept,
      Function? onDismiss}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            message,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (onReject != null) onReject();
                                NavHelper.pop(context);
                              },
                              child: Container(
                                  color: Colors.white,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      reject,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ))),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                NavHelper.pop(context);
                                if (onAccept != null) onAccept();
                              },
                              child: Container(
                                  color: Theme.of(context).primaryColor,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      accept,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
            contentPadding: EdgeInsets.all(0),
          );
        }).then((r) {
      if (onDismiss != null) onDismiss();
    });
  }

  static void text(BuildContext context,
      {String message = "", String close = "Close", Function? onDismiss}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            message,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                NavHelper.pop(context);
                              },
                              child: Container(
                                  color: Colors.white,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      close,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ))),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
            contentPadding: EdgeInsets.all(0),
          );
        }).then((r) {
      if (onDismiss != null) onDismiss();
    });
  }

  static void loading(bool b, {BuildContext? context}) {
    //context = context == null ? Global().context : context;
    if (b) {
      showDialog(
          context: context!,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
          barrierDismissible: false);
    } else {
      NavHelper.pop(context!);
    }
  }

  static void snackbar(String text,
      {Color? color,
      BuildContext? context,
      required GlobalKey<ScaffoldState> key}) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
    );
    if (context == null) context = Global().context;
    if (key != null) {
      //key.currentState.showSnackBar(snackBar);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  static void bottom(context, Widget child) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return child;
        });
  }
}
