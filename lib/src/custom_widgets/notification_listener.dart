import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationListener {
  void firebaseCloudMessagingListeners(context) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        sound: true);

    FirebaseMessaging.onMessage.listen((event) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        borderRadius: BorderRadius.circular(8),
        title: event.data['title'],
        message: event.data['message'],
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Color.fromRGBO(226, 0, 116, 1),
        ),
        duration: Duration(seconds: 5),
      )..show(context);
    });
  }
}
