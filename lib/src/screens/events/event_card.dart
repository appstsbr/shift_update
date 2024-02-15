import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/models/message.dart';
import 'package:shift_flutter/src/resources/event_type_data.dart';
import 'package:shift_flutter/src/resources/format_string.dart';
import 'package:shift_flutter/src/screens/details/details_screen.dart';
import 'package:shift_flutter/src/screens/main/main_screen.dart';

/// class [EventCard] e uma class responsavel pela criação
/// de cards que levam o usuario ate o evento de forma
/// mais detalhada

class EventCard extends StatelessWidget {
  final Message message;
  Strings strings = Strings();

  EventCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      child: Card(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () {
            showEventDetails(context);
          },
          borderRadius: new BorderRadius.all(Radius.circular(10)),
          child: Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 15),
            child: data(),
          ),
        ),
        elevation: 1,
        margin: EdgeInsets.all(0),
      ),
    );
  }

  Widget data() {
    List<String> date =
        FormatString.dateAndTime(message.lastHistory.createdAt!).split(" - ");
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              iconType(message.status),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      date[1],
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                    Text(
                      date[0],
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: statusMessage(),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              FormatString.capitalizeText(message.messageTitle),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: CustomTheme.shift().primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            subtitle:
                Text(FormatString.capitalizeText(message.messageDescription)),
            trailing:
                Icon(Icons.navigate_next, size: 30.0, color: Colors.grey[350])),
      )
    ]);
  }

  List<Widget> statusMessage() {
    if (message.status == "Informativo") {
      return [
        Text(strings.eventScreen.get("informative")),
        Container(
          width: 8,
        ),
        Icon(
          Icons.info,
          color: Colors.blue,
          size: 16,
        )
      ];
    } else {
      return [
        Text(EventTypeData.text(message.lastHistory.typeId!)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: EventTypeData.icon(message.lastHistory.typeId, size: 16),
        ),
      ];
    }
  }

  void showEventDetails(BuildContext context) {
    print(message.lastHistory.id);
    if (message.lastHistory.id == 0) {
      MainScreen.alert(
        strings.eventScreen.get("message_no_details"),
        Colors.white,
        Colors.black,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsScreen(
                  messageId: message.messageId,
                )),
      );
    }
  }

  Icon iconType(String status) {
    IconData ico;
    Color c;
    switch (status) {
      case "Informativo":
        ico = Icons.info_outline;
        c = Colors.grey;
        break;
      default:
        ico = Icons.warning;
        c = Colors.grey;
    }

    return Icon(
      ico,
      color: c,
      size: 16,
    );
  }
}
