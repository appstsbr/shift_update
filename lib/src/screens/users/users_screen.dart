import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/users/users_list.dart';

class UsersScreen extends StatefulWidget {
  _UsersScreenState createState() => _UsersScreenState();
  final int messageId;
  UsersScreen({required this.messageId});
}

class _UsersScreenState extends State<UsersScreen>
    with AutomaticKeepAliveClientMixin {
  final ShiftApiProvider provider = new ShiftApiProvider();
  List<User> users = [];
  List<User> usersReaded = [];
  List<User> usersUnread = [];
  bool _waitingData = true;

  Future<void> fetchData() async {
    setState(() {
      _waitingData = true;
    });
    users = await provider.getMessageUsers(widget.messageId);
    usersReaded = [];
    usersUnread = [];
    users.forEach((User u) {
      if (u.userCheckNotification == 1)
        usersUnread.add(u);
      else
        usersReaded.add(u);
    });
    users = [];
    users.addAll(usersReaded);
    users.addAll(usersUnread);
    setState(() {
      _waitingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (_waitingData) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor:
              AlwaysStoppedAnimation<Color>(CustomTheme.shift().primaryColor),
        ),
      );
    } else {
      return UsersList(users);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
