import 'package:flutter/material.dart';
import 'package:shift_flutter/src/helpers/nav_helper.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/details/details_screen.dart';
import '../../models/notification_user.dart';
import '../../resources/event_type_data.dart';
import '../../resources/format_string.dart';
import '../../resources/date_time_handler.dart';

/// class [NotificationItem] resposanvel por renderizar o evento vindo
/// da api em forma de card, levando o usuario ate a notificação de forma detalhada

class NotificationItem extends StatefulWidget {
  final NotificationUser notification;
  final int? index;
  NotificationItem({required Key key, required this.notification, this.index})
      : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isHidden = false;
  final ShiftApiProvider provider = new ShiftApiProvider();
  @override
  Widget build(BuildContext context) {
    if (isHidden) return Container();
    return Dismissible(
      key: ObjectKey(widget.index),
      onDismissed: (direction) {
        provider
            .markNotificationAsRead(widget.notification.notificationId!)
            .then((s) {});
        setState(() {
          isHidden = true;
        });
      },
      child: item(),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red[200],
      ),
    );
  }

  Widget item() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Card(
        color: EventTypeData.color(widget.notification.typeId!), //History Color
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        margin: EdgeInsets.all(0),
        elevation: 1,
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Card(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: InkWell(
                onTap: () async {
                  NavHelper.push(
                          context,
                          DetailsScreen(
                              messageId: widget.notification.messageId!))
                      .then((value) {
                    setState(() {
                      isHidden = true;
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: data(),
                ),
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              elevation: 0,
              margin: EdgeInsets.all(0),
            )),
      ),
    );
  }

  Widget data() {
    print(widget.notification.updatedAt);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              FormatString.fixTextLength(
                  FormatString.capitalizeText(
                      widget.notification.historyMessage!),
                  18),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              EventTypeData.text(widget.notification.typeId!),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              DateTimeHandler.getNotificationTimeInterval(
                  DateTime.parse(widget.notification.updatedAt!)),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        )
      ],
    );
  }
}
