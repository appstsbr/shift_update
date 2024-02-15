import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/message.dart';
import 'package:shift_flutter/src/models/user_activity.dart';
import 'package:shift_flutter/src/resources/event_type_data.dart';
import 'package:shift_flutter/src/resources/format_string.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/chat/chat_screen.dart';
import 'package:shift_flutter/src/screens/users/users_screen.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:shift_flutter/src/custom_widgets/notification_listener.dart';

class DetailsScreen extends StatefulWidget {
  final int messageId;

  const DetailsScreen({super.key, required this.messageId});

  // DetailsScreen({Key key, required this.messageId}) : super(key: key);

  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool _isLoading;
  late int _navigate;
  late Message message;
  ShiftApiProvider provider = new ShiftApiProvider();
  var notificationListener = new FirebaseNotificationListener();
  Strings strings = Strings();
  late UsersScreen usersScreen;
  ChatScreen chatScreen = ChatScreen();
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _navigate = 1;
    getMessage();
    provider.markAsRead(widget.messageId);

    notificationListener.firebaseCloudMessagingListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: FlatButton(
          child: Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          shape: CircleBorder(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[chatButton()],
        title: getAppBarTitlePlatform(),
      ),
      body: home(),
    );
  }

  Widget chatButton() {
    if (Global().user.canUseChat != 1) return Container();
    return IconButton(
      icon: Icon(Icons.chat),
      onPressed: () {
        NavHelper.push(
            context,
            ChatScreen(
              showActions: false,
              eventId: message.id,
              isClosed: message.closedAt != null ? true : false,
              isEnable: message.hasChat == 1 && Global().user.canUseChat == 1
                  ? true
                  : false,
              title: message.message,
            ));
      },
    );
  }

  Widget getAppBarTitlePlatform() {
    return Text(
      strings.detailScreen.get("info_event"),
      textAlign: TextAlign.center,
    );
  }

  Widget home() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
                CustomTheme.shift().primaryColor)),
      );
    }
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            isScrollable: false,
            indicatorColor: CustomTheme.shift().primaryColor,
            labelColor: Colors.grey,
            tabs: [
              Tab(text: strings.titles.get("details")),
              Tab(text: strings.titles.get("history")),
              Tab(text: strings.titles.get("participants")),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              details(),
              history(),
              UsersScreen(messageId: widget.messageId),
            ],
          ),
        ));
  }

  Widget history() {
    List<TimelineModel> items = [];
    for (UserActivity h in message.historys) {
      items.add(TimelineModel(
        itemTimeline(h),
        // position: items.length % 2 == 0
        //     ? TimelineItemPosition.right
        //     : TimelineItemPosition.left,
        position: TimelineItemPosition.right,
        iconBackground: EventTypeData.color(h.typeId!),
        icon: Icon(EventTypeData.iconData(h.typeId!), color: Colors.white),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 8),
      child: Timeline(
        children: items,
        position: TimelinePosition.Left,
        lineColor: Colors.grey[300],
      ),
    );
  }

  Widget details() {
    print(message.lastHistory.createdAt);
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              itemHeader(EventTypeData.iconData(message.lastHistory.typeId!),
                  strings.detailScreen.get("last_att"),
                  colorIcon: EventTypeData.color(message.lastHistory.typeId!)),
              itemDetail(
                message.lastHistory.title!,
                Text(message.lastHistory.autorName!),
                avatar: CircleAvatar(
                  backgroundImage:
                      NetworkImage(message.lastHistory.autorAvatar!),
                ),
              ),
              Divider(height: 1),
              itemDetail(
                strings.detailScreen.get("type"),
                Text(EventTypeData.text(message.lastHistory.typeId!)),
              ),
              Divider(height: 1),
              itemDetail(
                strings.detailScreen.get("time"),
                Text(FormatString.dateAndTime(message.lastHistory.createdAt!)),
              ),
              itemHeader(Icons.event_note, strings.detailScreen.get("event"),
                  colorIcon: CustomTheme.shift().primaryColor),
              itemDetail(
                message.title,
                Text(message.receiverName),
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(message.messageReceiverAvatar),
                ),
              ),
              itemDetail(
                strings.detailScreen.get("description"),
                Text(message.messageDescription),
              ),
              itemDetail(
                strings.detailScreen.get("type"),
                Text(message.status),
              ),
              itemDetail(
                strings.detailScreen.get("ticket"),
                Text(message.ticket),
              ),
              itemDetail(
                strings.detailScreen.get("opened"),
                Text(FormatString.dateAndTime(message.createdAt)),
              ),
              itemDetail(
                strings.titles.get("participants"),
                Text(message.totalReceivers.toString()),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget itemDetail(String title, Widget text, {action, Widget? avatar}) {
    Widget? next;
    if (action != null) {
      next = Icon(
        Icons.navigate_next,
        size: 35,
      );
    }
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: 30, right: 30),
          onTap: action,
          leading: avatar,
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: text,
          ),
          trailing: next,
        ),
        Divider(height: 1),
      ],
    );
  }

  Widget itemHeader(IconData icon, String text,
      {Color colorIcon: Colors.grey}) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: colorIcon),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTimeline(UserActivity history) {
    String time = FormatString.dateAndTime(history.createdAt!);
    String text = EventTypeData.text(history.typeId!);
    return Card(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 18, right: 30),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(history.autorAvatar!),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Text(
                    text.toUpperCase(),
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  )),
              Text(
                history.title!,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(history.autorName!),
                Text(time, style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMessage() async {
    setState(() {
      _isLoading = true;
    });
    message = await provider.getMessage(widget.messageId);
    Global().user = await provider.getLoggedUser();
    setState(() {
      _isLoading = false;
    });
  }
}
