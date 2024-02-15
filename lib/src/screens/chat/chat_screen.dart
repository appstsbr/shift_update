import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shift_flutter/src/helpers/global.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/chat_group.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/chat/chat_messages.dart';
import 'package:shift_flutter/src/screens/details/details_screen.dart';
import 'package:shift_flutter/src/screens/group_chat/group_detail_screen.dart';
import 'package:shift_flutter/src/screens/profile/image_picker_handler.dart';
import 'package:shift_flutter/src/services/firebase_auth_service.dart';
import 'package:shift_flutter/src/services/firestore_service.dart';

/// class [ChatScreen] responsavel pela criação dos chats chamando a class [ChatMessages]
/// a criação passa a ser de forma dinamica
/// com a verificação do evento, que varia entre id chat ou id group
class ChatScreen extends StatefulWidget {
  final int? eventId;
  final bool? isClosed;
  final bool isEnable;
  final bool showActions;
  final String? groupId;
  final bool isGroup;
  final ChatGroup? groupData;
  final String title;
  ChatScreen(
      {Key? key,
      this.eventId,
      this.isClosed,
      this.isEnable = true,
      this.showActions = true,
      this.groupId,
      this.isGroup = false,
      this.groupData,
      this.title = "Chat"})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  List _messages = [];
  TextEditingController textMessageController = TextEditingController();
  ShiftApiProvider providers = new ShiftApiProvider();
  late ScrollController scrollController;
  late User _user;
  bool start = false;
  bool isUploading = false;
  late ImagePickerHandler imagePicker;
  late var dataImageCrooped;

  @override
  void initState() {
    super.initState();
    Global().showPush = false;
    textMessageController = TextEditingController();
    scrollController = ScrollController();

    //imagePicker = new ImagePickerHandler(null, updateImage, chat: true);
    imagePicker = ImagePickerHandler(null, updateImage, chat: true);
  }

  void updateImage(dynamic file) {
    setState(() {
      this.userImage(file);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Global().showPush = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: widget.showActions
                    ? <Widget>[
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            if (widget.isGroup) {
                              NavHelper.push(
                                  context,
                                  GroupDetailScreen(
                                    userID: _user.id,
                                    isEdition: true,
                                    data: widget.groupData,
                                  )).then((value) {
                                if (value == "exit") {
                                  NavHelper.pop(context);
                                }
                              });
                            } else {
                              NavHelper.pushReplacement(
                                  context,
                                  DetailsScreen(
                                    messageId: widget.eventId!,
                                  ));
                            }
                          },
                        )
                      ]
                    : null,
              ),
              body: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/images/chat-bkg.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: widget.isGroup
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirestoreService()
                                  .getGroupMessages(widget.groupId.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Erro ao Acessar os dados"),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center();
                                } else {
                                  return ListView(
                                    reverse: true,
                                    controller: scrollController,
                                    children: snapshot.data!.docs.map((e) {
                                      print(e.data());
                                      return ChatMessages(
                                        message: e.data() as Map,
                                        user: _user,
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: FirestoreService()
                                  .getMessages(widget.eventId!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Erro ao Acessar os dados"),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center();
                                } else {
                                  return ListView(
                                    reverse: true,
                                    controller: scrollController,
                                    children: snapshot.data!.docs.map((e) {
                                      return ChatMessages(
                                        message: e.data() as Map,
                                        user: _user,
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                      bottomNavigationBar: bottomField(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }
        });
  }

  Widget item(Map<String, dynamic> msg) {
    return Card(
      child: Text(msg["message"]),
    );
  }

  Widget bottomField() {
    if (isUploading) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
            height: 50, child: Center(child: CircularProgressIndicator())),
      );
    }
    if (!widget.isEnable) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
              title: Text(
            Strings().eventScreen.get("chat_disable"),
            softWrap: true,
            maxLines: 2,
          )),
        ),
      );
    }
    if (widget.isClosed!) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
              title: Text(
            Strings().eventScreen.get("chat_done"),
            softWrap: true,
            maxLines: 2,
          )),
        ),
      );
    }
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: TextField(
                      controller: textMessageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, right: 15, top: 2, bottom: 2),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText:
                              Strings().eventScreen.get("chat_write_message"),
                          fillColor: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 12,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Icon(Icons.image),
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              await imagePicker
                                  .openGallery()
                                  .then((value) => userImage(value));
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.camera_alt),
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              await imagePicker
                                  .openCamera()
                                  .then((value) => userImage(value));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(left: 10),
              //color: Color(0xFFe20074),
              child: RaisedButton(
                  onPressed: send,
                  color: Color(0xFFe20074),
                  elevation: 1,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }

  Future getUser() async {
    return await providers.getLoggedUser().then((u) {
      _user = u;
      return _user;
    }).catchError((e) {
      print(e);
    });
  }

  void send() async {
    if (textMessageController.text != "") {
      widget.isGroup
          ? FirestoreService().sendMessageGroup(
              textMessageController.text, widget.groupData!, _user, "text")
          : FirestoreService().sendMessageChat(
              textMessageController.text, widget.eventId!, _user, "text");
      textMessageController.text = "";
    }
  }

  void moveToEnd() {
    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  Future userImage(File image) async {
    textMessageController.text = "";
    var user = await FirebaseAuthService.getCurrentUser();
    var uuid = DateTime.now().toIso8601String() + user.uid;
    print("\n\n*************** $uuid  ***************\n\n");

    final task = FirebaseStorage.instance
        .ref()
        .child(widget.isGroup ? widget.groupId! : widget.eventId.toString())
        .child(uuid)
        .putFile(image);

    setState(() {
      isUploading = true;
    });
    task.then((a) {
      a.ref.getDownloadURL().then((link) async {
        print("********* $link **********\n\n");
        setState(() {
          isUploading = false;
        });

        widget.isGroup
            ? FirestoreService().sendImageGroupChat(
                "Send a image", link, widget.groupId!, _user)
            : FirestoreService().sendImageChat(
                "Sended a image", image.path, widget.eventId!, _user);
      });
    }).catchError((e) {
      setState(() {
        isUploading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
