import 'package:flutter/material.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/screens/chat/chat_list_screen.dart';
import 'package:shift_flutter/src/screens/events/events_screen.dart';
import 'package:shift_flutter/src/screens/group_chat/group_chat_list_screen.dart';
import 'package:shift_flutter/src/screens/profile/profile_screen.dart';
import 'package:shift_flutter/src/screens/templates/t_pageview.dart';
import '../notification/notification_screen.dart';
import 'package:shift_flutter/src/custom_widgets/notification_listener.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// class [MainScreen] e responsavel por exibir ao usuario
/// todas as funcionalidades da aplicação
/// que vão de ,Notificações, Chats, Eventos e Perfil

class MainScreen extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

  static void alert(
    String text,
    Color textColor,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Container(
            height: 20,
            child: Center(
                child: Text(
              text,
              style: TextStyle(color: textColor),
            ))),
      ),
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Strings strings = Strings();
  late NotificationScreen notificationScreen;
  late EventsScreen eventsScreen;
  late ProfileScreen profileScreen;
  late List<Widget> _widgetOptions;
  late List<String> _titleOptions;
  ChatListScreen chatListScreen = ChatListScreen();
  GroupChatScreen groupChartScreen = GroupChatScreen();

  var notificationListener = FirebaseNotificationListener();
  var provider = ShiftApiProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _titleOptions = [
      strings.titles.get("notifications"),
      "Chat",
      strings.titles.get("events"),
      strings.titles.get("profile"),
    ];
    notificationScreen = NotificationScreen();
    eventsScreen = EventsScreen();
    profileScreen = ProfileScreen();
    _widgetOptions = [
      notificationScreen,
      groupChartScreen,
      eventsScreen,
      profileScreen
    ];
    notificationListener.firebaseCloudMessagingListeners(context);
    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    //DESENHAR TELAS
    return Scaffold(
      key: MainScreen.scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Text(_titleOptions[_selectedIndex],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ))),
      ),
      body: TPageview(
        bottomNavigationBarItem: [
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: _titleOptions[0]),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: _titleOptions[1]),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note), label: _titleOptions[2]),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: _titleOptions[3]),
        ],
        pages: _widgetOptions,
        onPageChange: (prev, next) {
          setState(() {
            _selectedIndex = next;
          });
        },
      ),
    );
  }

  void firebaseCloudMessagingListeners() {
    //if (Platform.isIOS) iOSPermission();
    if (Platform.isIOS) {
      readFileWithTokenNumber().then((token) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        deviceInfo.iosInfo.then((di) {
          // print("O token é $token");
          provider
              .sendUserDeviceInfo(
                  token, di.systemVersion, di.systemName, di.model, di.name)
              .then((statusCode) {
            // print("Retornou $statusCode");
          });
        });
      });
    } else {
      _firebaseMessaging.getToken().then((token) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          // print("entrou aqui");
          deviceInfo.androidInfo.then((di) {
            provider.sendUserDeviceInfo(
                token!, "Android", "Android", di.model, di.device);
          });
        }
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    //print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/shift.txt');
  }

  Future<String> readFileWithTokenNumber() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
