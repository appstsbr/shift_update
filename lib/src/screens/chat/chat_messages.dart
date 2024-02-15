import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shift_flutter/src/helpers/date_helper.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/user.dart';

///class [ChatMessages] responsavel pela criação do chat atribuindo
///o local e posicionamento das mensagens na tela
///de acordo com o user
class ChatMessages extends StatelessWidget {
  final Map<dynamic, dynamic>? message;
  final User? user;
  const ChatMessages({Key? key, this.message, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return user?.id == message!["user_id"]
        ? messageSent(context)
        : messageReceived(context);
  }

  Widget messageReceived(context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
      width: MediaQuery.of(context).size.width,
      child: Flex(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(5.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "~" + message!["name"],
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                message!.containsKey("img")
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HeroPhotoViewWrapper(
                                  imageProvider: NetworkImage(message!["img"]),
                                  tag: message!["img"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Hero(
                              tag: message!["img"],
                              child:
                                  Image.network(message!["img"], width: 170.0),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        message!["message"],
                        style: TextStyle(height: 1.3, color: Colors.black),
                      ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  DateHelper.defaultFormatNoDate(message!["date"].toDate()),
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                )
              ],
            ),
          ),
        ],
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  Widget messageSent(context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
        width: MediaQuery.of(context).size.width,
        child: Flex(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Color(0xffe20074),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  message!.containsKey("img")
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeroPhotoViewWrapper(
                                    imageProvider:
                                        NetworkImage(message!["img"]),
                                    tag: message!["img"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Hero(
                                  tag: message!["img"],
                                  child: Image.network(
                                    message!["img"],
                                  )),
                            ),
                          ),
                        )
                      : Text(
                          message!["message"],
                          style: TextStyle(height: 1.3, color: Colors.white),
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateHelper.defaultFormatNoDate(message!["date"].toDate()),
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  )
                ],
              ),
            ),
          ],
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
        ));
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  HeroPhotoViewWrapper({
    this.imageProvider,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.tag,
  });

  final ImageProvider? imageProvider;
  final Widget? loadingChild;
  final Decoration? backgroundDecoration;
  final dynamic? minScale;
  final dynamic? maxScale;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings().eventScreen.get("chat_imagem")),
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          //loadingChild: loadingChild,
          //backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroAttributes: PhotoViewHeroAttributes(tag: tag!),
        ),
      ),
    );
  }
}
