import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/custom_widgets/pre_dialog.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/user.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/login/login_screen.dart';
import 'package:shift_flutter/src/screens/main/main_screen.dart';
import 'package:shift_flutter/src/screens/profile/animation_profile.dart';
import 'package:shift_flutter/src/screens/profile/passoword_reset.dart';
import 'package:shift_flutter/src/services/http_service.dart';
import 'package:shift_flutter/src/screens/profile/image_picker_handler.dart';
import 'package:url_launcher/url_launcher.dart';

///class [ProfileScreen] responsavel por renderizar
/// a tela de perfil de usuario, exibindo assim
/// avatar, trocar de senha, politica de privacidade, sair, e os dados do usuario
class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with
        TickerProviderStateMixin,
        ImagePickerListener,
        AutomaticKeepAliveClientMixin {
  late AnimationController animController;
  late ProfileAnimations anim;
  ShiftApiProvider providers = new ShiftApiProvider();
  HttpService http = new HttpService();
  late User _profile;
  late File _image;

  late ImagePickerHandler imagePicker;

  late bool _waitingProfile;
  bool _waitingUploadImage = false;
  bool _connectionError = false;

  Strings strings = Strings();

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    anim = ProfileAnimations(control: animController);

    try {
      imagePicker = new ImagePickerHandler(animController, updateImage);
      imagePicker.init();
      getProfile();
    } catch (e) {
      _connectionError = true;
    }
  }

  void updateImage(dynamic file) {
    setState(() {
      this.userImage(file);
    });
  }

  @override
  userImage(File _image) {
    print(_image);
    setState(() {
      this._image = _image;
      changeAvatar();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionError) return Text(strings.errors.get("error_server"));
    if (_waitingProfile) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
      );
    } else
      return AnimatedBuilder(
        animation: animController,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: RefreshIndicator(
              onRefresh: getProfile,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    avatar(),
                    profileName(),
                    profileData(),
                    button(strings.profileScreen.get("change_pass"),
                        showDialogResetPassoword),
                    button(strings.profileScreen.get("logout"), logout),
                    button(strings.loginScreen.get("privacypolicy"),
                        _privacyPolicy)
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  Widget avatar() {
    if (_waitingUploadImage) {
      return Center(
        child: CircleAvatar(
          child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                  CustomTheme.shift().primaryColor)),
        ),
      );
    } else
      return Center(
        child: Transform.scale(
          child: Stack(children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: new CircleAvatar(
                backgroundImage: NetworkImage(_profile.img!),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => imagePicker.showDialog(context),
                  //onPressed: changeAvatar,
                  child:
                      Icon(Icons.edit, color: CustomTheme.shift().primaryColor),
                ))
          ]),
          scale: anim.scale1!.value,
        ),
      );
  }

  Widget profileName() {
    return Transform.scale(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(_profile.userFullName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "shift")),
        ),
      ),
      scale: anim.scale2!.value,
    );
  }

  Widget profileData() {
    return Transform.scale(
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, bottom: 30),
        child: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                strings.profileScreen.get("email"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_profile.userEmail),
              Text(
                strings.profileScreen.get("phone"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_profile.userPhone)
            ],
          ),
        ),
      ),
      scale: anim.scale3!.value,
    );
  }

  Widget button(String text, onPressed) {
    return Transform.scale(
      child: Center(
        child: Container(
          width: 200,
          child: GestureDetector(
              onTap: onPressed,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 225, 226, 226),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: CustomTheme.shift().primaryColor,
                    fontSize: 14,
                  ),
                ),
              )),
        ),
      ),
      scale: anim.scale4!.value,
    );
  }

  Future<void> getProfile() async {
    setState(() {
      _waitingProfile = true;
    });
    _profile = await providers.getLoggedUser();
    setState(() {
      _waitingProfile = false;
    });

    animController.forward();
  }

  void logout() async {
    PreDialog.confirm(
      context: context,
      title: strings.profileScreen.get("logout"),
      description: strings.profileScreen.get("message_logout"),
      cancel: strings.profileScreen.get("no"),
      confirm: strings.profileScreen.get("yes"),
      onConfirmed: () async {
        setState(() {
          _waitingProfile = true;
        });
        await http.logout();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      },
    );
  }

  void showDialogResetPassoword() {
    PreDialog.open(
      context: context,
      child: PasswordReset(),
    );
  }

  Future changeAvatar() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var image = this._image;
    //File f = await FilePicker.getFile(type: FileType.IMAGE);
    List<String> aux = image.path.split(".");
    String ext = aux[aux.length - 1];

    if (ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "bmp") {
      setState(() {
        _waitingUploadImage = true;
      });
      String base64Image = base64Encode(image.readAsBytesSync());
      providers.changeAvatar(base64Image, ext).then((s) {
        setState(() {
          _waitingUploadImage = false;
        });
        if (s == 200) {
          getProfile();
        } else
          MainScreen.alert(
              strings.errors.get("error_unknow"), Colors.white, Colors.red);
      }).catchError((error) {
        MainScreen.alert(
            strings.errors.get("error_upload_image"), Colors.white, Colors.red);
        setState(() {
          _waitingUploadImage = false;
        });
      });
    } else
      MainScreen.alert(strings.profileScreen.get("validation_image"),
          Colors.white, Colors.red);
  }

  void _privacyPolicy() async {
    const url = 'https://shift.t-systems.com.br/privacy';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Erro ao Carregar';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
