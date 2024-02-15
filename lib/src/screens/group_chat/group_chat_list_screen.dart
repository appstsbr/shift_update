import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shift_flutter/src/helpers/avatar_user.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/chat_group.dart';
import 'package:shift_flutter/src/resources/date_time_handler.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/chat/chat_screen.dart';
import 'package:shift_flutter/src/screens/group_chat/group_edit_participants.dart';
import 'package:shift_flutter/src/services/firestore_service.dart';
import 'package:shift_flutter/src/services/shift_local_storage.dart';

/// class [GroupChatScreen] responsavel por listar
/// todos os grupos na qual o usuario participa.
/// alem da opção para criação de novos grupos

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen({Key? key}) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late SharedPreferences prefs;
  var provider = new ShiftApiProvider();
  late StreamSubscription streamListen;
  List _groups = [];
  Strings strings = Strings();
  bool _isRefresh = false;

  Future _data() async {
    setState(() {
      _isRefresh = true;
    });
    var u = await provider.getLoggedUser();
    Global().user = u;
    if (u.canUseChat == 1) {
      streamListen = FirestoreService().streamGroups(u.id!).listen((onData) {
        if (onData.docs == null) {
          _groups = [];
          setState(() {});
        } else {
          _groups = onData.docs;
          setState(() {});
        }
      }, onError: (e) {
        print(e);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _data().then((value) {
      setState(() {
        _isRefresh = false;
      });
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRefresh) {
      if (Global().user.canUseChat != 1) {
        return Center(
          child: Text(strings.eventScreen.get("chat_disable")),
        );
      } else {
        return Container(
          child: Container(
            child: Column(
              children: <Widget>[
                createGroup(),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  color: Colors.grey.shade300,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 1,
                ),
                _groups == null
                    ? Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(strings.eventScreen.get("chat_disable")),
                        ),
                      )
                    : Expanded(
                        child: listView(),
                      ),
              ],
            ),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe20074))),
      );
    }
  }

  Widget listView() {
    if (_groups.length == 0) {
      return Center(child: Text(strings.groupScreen.get("empty_groups")));
    } else {
      return ListView.builder(
          itemCount: _groups.length,
          itemBuilder: (context, index) {
            ChatGroup group =
                ChatGroup.fromJSON(_groups[index].data(), _groups[index].id);
            return groupItem(
              group: group,
            );
          });
    }
  }

  Widget createGroup() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: InkWell(
        onTap: () {
          NavHelper.push(context, GroupEditParticipantsScreen()).then((value) {
            setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: ListTile(
            title: Text(strings.groupScreen.get("new_group")),
            leading: AvatarUser(
              name: "Novo",
              size: 45,
              assetImg: "assets/images/group.png",
            ),
          ),
        ),
      ),
    );
  }

  Widget groupItem({ChatGroup? group}) {
    print(
        "********* ${Global().user.canUseExternalChat} ********* canUseExternal");
    return InkWell(
      onTap: () {
        ShiftLocalStorage()
            .saveToStorage(group!.id.toString(), group.lastId.toString());
        NavHelper.push(
            context,
            ChatScreen(
              isEnable: Global().user.canUseExternalChat == 1 ? true : false,
              isClosed: false,
              groupId: group.id,
              showActions: Global().user.canUseExternalChat == 1 ? true : false,
              isGroup: true,
              groupData: group,
              title: group.name.toString(),
            )).then(
          (value) {
            setState(() {});
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ListTile(
          leading: AvatarUser(
            name: group!.name.toString(),
          ),
          title: Text(group.name.toString()),
          subtitle: group.last == null
              ? null
              : Text(
                  group.last.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          trailing: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                    DateTimeHandler.dateTimeToHour(
                        DateTime.parse(group.update.toString())),
                    style: TextStyle(
                      color: Color(0xff4e4e4e),
                      fontSize: 12,
                    )),
                group.last == null
                    ? Container(
                        padding: EdgeInsets.only(
                            right: 10, left: 10, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                          color: Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Novo grupo",
                          style: TextStyle(
                            color: Color(0xff4e4e4e),
                            fontSize: 12,
                          ),
                        ),
                      )
                    : ShiftLocalStorage().compareMessageIds(
                            prefs, group.id.toString(), group.lastId.toString())
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.only(
                                right: 10, left: 10, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              color: Color(0xffd9d9d9),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Nova msg",
                              style: TextStyle(
                                color: Color(0xff4e4e4e),
                                fontSize: 12,
                              ),
                            ),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
