import 'package:flutter/material.dart';
import 'package:shift_flutter/src/custom_widgets/notification_listener.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/services/http_service.dart';
import 'CustomTheme.dart';
import 'package:flutter/services.dart';

import 'start.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var httpService = new HttpService();
  var shiftProvider = new ShiftApiProvider();

  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);

  var notificationListener = FirebaseNotificationListener();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
    notificationListener.firebaseCloudMessagingListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.shift(),
      home: Start(),
    );
  }
}
