import 'package:flutter/material.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/helpers/avatar_user.dart';
import 'package:shift_flutter/src/helpers/dialogs_helper.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/chat_group.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/group_chat/group_edit_participants.dart';
import 'package:shift_flutter/src/services/firestore_service.dart';

/// class [GroupDetailScreen] responsavel pelos detalhes do grupo
/// como remoção ou adição de administração dos usuarios, exclusão e edição do grupo
/// como exlcusao do propio grupo, como editar o nome do mesmo.
class GroupDetailScreen extends StatefulWidget {
  final ChatGroup? data;
  final bool? isEdition;
  final int? userID;
  GroupDetailScreen({Key? key, this.data, this.isEdition = false, this.userID})
      : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  TextEditingController searchController = TextEditingController();
  List<User> users = [];
  List<int> admins = [];
  var provider = new ShiftApiProvider();
  String searchText = "";
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  Strings strings = Strings();
  bool _refreshData = false;

  @override
  void initState() {
    widget.data!.usersData?.forEach((u) {
      users.add(u);
    });
    if (widget.isEdition == false) {
      nameFocus.requestFocus();
      widget.data!.admin = [Global().user.id];
    }
    if (widget.data!.admin != null) {
      widget.data!.admin?.forEach((u) {
        admins.add(u);
      });
    }
    syncAdminList();

    nameController.text = widget.data!.name.toString();

    super.initState();
  }

  void deleteGroup(dynamic opc) {
    DialogsHelper.confirm(context,
        message: strings.groupScreen.get("delete_group_confirm"),
        onAccept: () async {
      //DialogsHelper.loading(true, context: context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }));
      try {
        await FirestoreService().deleteGroup(widget.data!.id.toString());
        NavHelper.pop(context); //loading
        NavHelper.pop(context); //tela atual
        NavHelper.pop(context, returnValue: "exit"); //tela chat
      } catch (e) {
        NavHelper.pop(context); //loading
        DialogsHelper.error(message: e.toString());
      }
    });
  }

  bool isAdmin({User? u}) {
    if (u == null) u = Global().user;
    if (admins.length == 0) {
      return u.id == users[0].id ? true : false;
    }
    if (admins.contains(u.id)) return true;
    return false;
  }

  void syncAdminList() {
    print("sync");
    List<int> list = [];

    for (var adm in admins) {
      for (var user in users) {
        if (user.id == adm) list.add(adm);
      }
    }
    admins = list;
    setState(() {});
  }

  void setAdmin(int uid, bool admin) {
    if (admin)
      admins.add(uid);
    else if (admins.length > 1) {
      admins.remove(uid);
    }
    setState(() {});
  }

  Widget deleteWidget() {
    if (widget.isEdition == false || !isAdmin()) return Container();
    List choices = [Text(strings.groupScreen.get("delete_group"))];
    return PopupMenuButton<dynamic>(
      onSelected: deleteGroup,
      itemBuilder: (BuildContext context) {
        return choices.map((dynamic choice) {
          return PopupMenuItem<dynamic>(
            value: choice,
            child: choice,
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.groupScreen.get("details")),
        actions: <Widget>[deleteWidget()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isAdmin()
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextField(
                        focusNode: nameFocus,
                        controller: nameController,
                        onChanged: (s) {
                          if (s.length == 0 || s.length == 1) setState(() {});
                        },
                        decoration: InputDecoration(
                            labelText: strings.groupScreen.get("name"),
                            border: OutlineInputBorder()),
                      ),
                    )
                  : ListTile(
                      title: Text(strings.groupScreen.get("name")),
                      subtitle: Text(widget.data!.name.toString()),
                    ),
              Container(
                height: 10,
              ),
              Text(strings.groupScreen.get("participants")),
              Container(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: usersItem(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: nameController.text != "" && isAdmin()
          ? FloatingActionButton(onPressed: saveGroup, child: Icon(Icons.check))
          : null,
    );
  }

  List<Widget> usersItem() {
    List<Widget> items = [];
    if (isAdmin()) {
      items.add(InkWell(
        onTap: () {
          NavHelper.push(
              context,
              GroupEditParticipantsScreen(
                users: users,
                isEdtion: true,
              )).then((value) {
            if (value == null) return;
            setState(() {
              users = value;
              syncAdminList();
            });
          });
        },
        child: ListTile(
            leading: Container(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(strings.groupScreen.get("edit_part"))),
      ));
    }
    items.add(Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Divider(
        height: 1,
      ),
    ));
    users.forEach((u) {
      items.add(ListTile(
        leading: AvatarUser(
          src: u.img,
        ),
        title: Text(
          u.name!,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: userItemWidget(u),
      ));
    });

    return items;
  }

  Widget userItemWidget(User u) {
    Function action = () {};
    String text = "";
    List<Widget> actions = [];

    if (isAdmin(u: u)) {
      text = "ADMIN";
      action = () {};
      if (isAdmin()) {
        if (Global().user.id != u.id) {
          actions.add(ListTile(
            title: Center(
                child:
                    Text(strings.groupScreen.get("remove_admin_permission"))),
            onTap: () {
              setAdmin(u.id!, false);
              NavHelper.pop(context);
            },
          ));
        } else if (widget.isEdition == true) {
          actions.add(ListTile(
            title: Center(child: Text(strings.groupScreen.get("exit_group"))),
            onTap: () {
              NavHelper.pop(context);
              removeUser(u);
            },
          ));
        }
      }
    } else if (Global().user.id == u.id && widget.isEdition == true) {
      text = strings.groupScreen.get("exit_group");
      action = () {
        removeUser(u);
      };
    } else if (isAdmin()) {
      return IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
              builder: (BuildContext context) {
                return Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        title: Center(
                            child: Text(strings.groupScreen
                                .get("add_admin_permission"))),
                        onTap: () {
                          setAdmin(u.id!, true);
                          NavHelper.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
              context: context);
        },
      );
    }
    if (text == "") return SizedBox();
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              builder: (BuildContext context) {
                return Container(
                  child: Wrap(
                    children: actions,
                  ),
                );
              },
              context: context);
        },
        child: Container(
          padding: EdgeInsets.only(right: 10, left: 10, top: 3, bottom: 3),
          decoration: BoxDecoration(
            color: Color(0xffd9d9d9),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xff4e4e4e),
              fontSize: 12,
            ),
          ),
        ));
  }

  void removeUser(User u) {
    if (admins.length < 2 && users.length > 1 && isAdmin()) {
      DialogsHelper.text(context, message: "Set an administrator before leave");
    } else {
      DialogsHelper.confirm(context,
          message: strings.groupScreen.get("exit_group_confirm"),
          onAccept: () async {
        users.remove(u);
        setAdmin(u.id!, false);
        var b = await saveGroup();
        print(b);
        if (b) NavHelper.pop(context); //tela de chat
      });
    }
  }

  Future<bool> saveGroup() async {
    //nome do grupo
    widget.data!.name = nameController.text;
    // seta os objetos users
    widget.data!.usersData = users;
    //seta os admins
    widget.data!.admin = admins;

    List<String> usersId = [];
    //seta todos os objetos userData para a lista userID, pegando assim apenas os ids de cada users
    widget.data!.usersData?.forEach((u) {
      usersId.add(u.id.toString());
    });
    widget.data!.users = usersId;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }));
    try {
      Map<String, dynamic> m = widget.data!.toMap();
      m.remove("last");
      await FirestoreService().saveGroup(m);
      NavHelper.pop(context);
      NavHelper.pop(context);
      return true;
    } catch (e) {
      NavHelper.pop(context); //loading
      DialogsHelper.error(message: e.toString());
      return false;
    }
  }
}
