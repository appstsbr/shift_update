import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/screens/users/users_item.dart';

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList(this.users);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (context, int index) {
        if (index == 0) return totalUsers();
        return buildItem(users[index - 1]);
        //return
      },
    );
  }

  Widget buildItem(User user) {
    return Container(
      child: UsersItem(user),
    );
  }

  Widget totalUsers() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Text(
        "${users.length} " + Strings().titles.get("participants"),
        style: TextStyle(color: CustomTheme.shift().primaryColor, fontSize: 15),
      ),
    );
  }
}
