import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/user.dart';

class UsersItem extends StatelessWidget {
  final User user;

  UsersItem(this.user);

  @override
  Widget build(BuildContext context) {
    print(user.userCheckNotification);
    return Container(
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  margin: EdgeInsets.all(20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.userImg),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(user.userFullName,
                          style: TextStyle(fontSize: 16)),
                      margin: EdgeInsets.only(bottom: 6),
                    ),
                    Row(
                      children: notifiedStatus(user.userCheckNotification),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        Divider(
          color: Colors.black12,
          height: 0,
        )
      ],
    ));
  }

  List<Widget> notifiedStatus(int check) {
    if (check == 1) {
      return <Widget>[
        Icon(
          Icons.check,
          size: 12,
          color: Colors.grey[400],
        ),
        Container(
          margin: EdgeInsets.only(left: 3),
          child: Text(
            Strings().eventScreen.get("notification_not_read"),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
        )
      ];
    } else {
      return <Widget>[
        Icon(
          Icons.check,
          size: 12,
          color: Color.fromRGBO(226, 0, 116, 1),
        ),
        Container(
          margin: EdgeInsets.only(left: 3),
          child: Text(
            Strings().eventScreen.get("notification_read"),
            style: TextStyle(
                fontSize: 13,
                color: CustomTheme.shift().primaryColor,
                fontWeight: FontWeight.w300),
          ),
        )
      ];
    }
  }
}
