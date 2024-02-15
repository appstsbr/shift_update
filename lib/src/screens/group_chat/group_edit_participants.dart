import 'package:flutter/material.dart';
import 'package:shift_flutter/src/custom_widgets/refresher_list.dart';
import 'package:shift_flutter/src/helpers/avatar_user.dart';
import 'package:shift_flutter/src/helpers/custom_controller.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/chat_group.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/group_chat/group_detail_screen.dart';

/// class [GroupEditParticipantsScreen] responsavel pelo gerenciamento
/// de usuarios na criação dos grupos, listando, adicionando e removendo
/// os usuarios cadastrados do banco da t-systems

class GroupEditParticipantsScreen extends StatefulWidget {
  final bool isEdtion;
  final List<User>? users;
  GroupEditParticipantsScreen({Key? key, this.isEdtion = false, this.users})
      : super(key: key);

  @override
  _GroupEditParticipantsScreenState createState() =>
      _GroupEditParticipantsScreenState();
}

class _GroupEditParticipantsScreenState
    extends State<GroupEditParticipantsScreen> {
  TextEditingController searchController = TextEditingController();
  List<User> users = [];
  var provider = new ShiftApiProvider();
  String searchText = "";
  CustomController listController = CustomController();
  bool toggleSearch = false;
  FocusNode focusSearch = FocusNode();
  ScrollController userScrollController = ScrollController();
  late User loggedUser;
  Strings strings = Strings();

  @override
  void initState() {
    if (widget.users != null) {
      widget.users!.forEach((u) {
        users.add(u);
      });
    }
    provider.getLoggedUser().then((u) {
      setState(() {
        loggedUser = u;
        if (!widget.isEdtion) users.add(u);
      });
    });
    toggleSearch = true;
    focusSearch.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !toggleSearch
          ? AppBar(
              title: Text(strings.groupScreen.get("participants")),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      toggleSearch = true;
                      focusSearch.requestFocus();
                    });
                  },
                )
              ],
            )
          : searchBar(),
      body: Scaffold(
        appBar: usersSelected(),
        body: RefresherList(
          controller: listController,
          item: (item) {
            return participantCard(item);
          },
          provider: (int page) {
            return provider.searchUsers(searchText, page);
          },
          textNoItems: strings.groupScreen.get("empty"),
        ),
      ),
      floatingActionButton: users.length > 0
          ? FloatingActionButton(
              onPressed: goToDetail, child: Icon(Icons.check))
          : null,
    );
  }

  void search(String s) {
    focusSearch.requestFocus();
    setState(() {
      searchText = s;
    });
    listController.get("refresh")();
  }

  AppBar searchBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              toggleSearch = false;
              search("");
            });
          },
        )
      ],
      title: Container(
        margin: EdgeInsets.all(10),
        child: TextField(
          focusNode: focusSearch,
          controller: searchController,
          maxLines: 1,
          textInputAction: TextInputAction.search,
          style: TextStyle(color: Colors.white, fontSize: 20),
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
              hintText: strings.groupScreen.get("search"),
              fillColor: Colors.white),
          onSubmitted: search,
        ),
      ),
    );
  }

  usersSelected() {
    if (users.length == 0) return null;
    return PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              child: ListView.builder(
                controller: userScrollController,
                itemCount: users.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (users[index].id != Global().user.id)
                          users.removeAt(index);
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: <Widget>[
                                AvatarUser(
                                  src: users[index].img,
                                ),
                                users[index].id != Global().user.id
                                    ? icon(Icons.close, Colors.red)
                                    : SizedBox()
                              ],
                            ),
                          ),
                          Text(
                            users[index].name!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            )
          ],
        ));
  }

  int getIndexUser(User u) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == u.id) return i;
    }
    return -1;
  }

  Widget participantCard(User u) {
    return InkWell(
      onTap: () {
        setState(() {
          if (!userIsAdded(u)) {
            users.add(u);
          } else if (Global().user.id != u.id) users.removeAt(getIndexUser(u));
        });
        setState(() {
          if (users.length > 2) {
            userScrollController.animateTo(
                userScrollController.position.maxScrollExtent + 100,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ListTile(
          leading: Stack(
            children: <Widget>[
              AvatarUser(
                name: u.name!,
                src: u.img,
              ),
              userIsAdded(u) ? icon(Icons.check, Colors.green) : Text("")
            ],
          ),
          title: Text(u.name!),
        ),
      ),
    );
  }

  Widget icon(IconData icon, Color c) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        height: 20,
        width: 20,
        child: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.white,
            size: 10,
          ),
          backgroundColor: c,
        ),
      ),
    );
  }

  bool userIsAdded(User user) {
    for (var u in users) {
      if (u.id == user.id) return true;
    }
    return false;
  }

  void goToDetail() {
    if (widget.isEdtion)
      NavHelper.pop(context, returnValue: users);
    else {
      NavHelper.push(
          context,
          GroupDetailScreen(
            data: ChatGroup(name: "", usersData: users),
          )).then((_) => NavHelper.pop(context));
    }
  }
}
