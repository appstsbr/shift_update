import 'package:shift_flutter/src/models/user.dart';

class ChatGroup {
  String? id;
  String? last;
  String? lastId;
  List<String>? users;
  List<User>? usersData;
  DateTime? update;
  String? name;
  List<dynamic>? admin;

  ChatGroup(
      {this.last,
      this.update,
      this.users,
      this.name,
      this.id,
      this.usersData,
      this.lastId,
      this.admin});

  static ChatGroup fromJSON(Map<String, dynamic> data, String id) {
    List<String> usersList = [];
    List<User> usersDataList = [];

    if (data["users"] != null) {
      for (var u in data["users"]) {
        usersList.add(u);
      }
    }

    if (data["usersData"] != null) {
      for (var u in data["usersData"]) {
        usersDataList.add(User.fromJson(Map.from(u)));
      }
    }

    return ChatGroup(
        id: id,
        last: data.containsKey("last") ? data["last"].toString() : "",
        lastId: data["last_id"],
        update: data["update"].toDate(),
        users: usersList,
        usersData: usersDataList,
        name: data["name"].toString(),
        admin: data["admin"]);
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> mapsUserData = [];
    usersData!.forEach((u) {
      mapsUserData.add(u.toMap());
    });
    return {
      "id": id,
      "last": last,
      "users": users,
      "usersData": mapsUserData,
      "update": update,
      "name": name,
      "admin": admin,
    };
  }
}
