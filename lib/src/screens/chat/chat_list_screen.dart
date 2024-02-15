import 'package:flutter/material.dart';
import 'package:shift_flutter/src/custom_widgets/refresher_list_simple.dart';
import 'package:shift_flutter/src/helpers/date_helper.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/chat/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var provider = new ShiftApiProvider();
  Strings strings = Strings();

  @override
  void initState() {
    provider.getLoggedUser().then((value) {
      Global().user = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefresherListSimple(
        itemBuiler: (data) {
          return item(data);
        },
        onRefresh: provider.getChatList,
        textNoItems:
            "No chat avaiable.\nTry go to a event and tap icon chat on top",
      ),
    );
  }

  Widget item(dynamic data) {
    return GestureDetector(
      onTap: () {
        NavHelper.push(
            context,
            ChatScreen(
              eventId: data["message_id"],
              isClosed: data["closed_at"] != null ? true : false,
              showActions: false,
              title: data["title"],
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(data["user"]["img"]),
            ),
            title: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: Text(
                    data["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Text(
                    DateHelper.chat(
                      DateTime.parse(data["created_at"]),
                    ),
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 8),
                Text(
                  data["user"]["name"] + ": " + data["chat"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Container(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
