import 'package:flutter/material.dart';
import 'package:shift_flutter/src/custom_widgets/refresher_list.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/screens/notification/notification_item.dart';
import '../../models/notification_user.dart';
import '../../resources/shift_api_provider.dart';

///class [NotificationScreen] é responsavel por fazer uma requisição
///ao servidor para verificação de novas atualizações referentes a eventos

class NotificationScreen extends StatefulWidget {
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  final ShiftApiProvider provider = new ShiftApiProvider();

  List<NotificationUser> userNotifications = [];
  Strings strings = Strings();
  bool _waitingData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefresherList(
      item: (item) {
        return NotificationItem(
            key: Key(item.notificationId.toString()), notification: item);
      },
      provider: (int page) {
        return provider.getUserNotifications(10, page);
      },
      textNoItems: strings.notificationScreen.get("message_empty"),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
