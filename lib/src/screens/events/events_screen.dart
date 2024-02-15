import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/custom_widgets/refresher_list.dart';
import 'package:shift_flutter/src/lang/Strings.dart';
import 'package:shift_flutter/src/resources/shift_api_provider.dart';
import 'package:shift_flutter/src/screens/events/event_card.dart';

/// class [EventsScreen] e responsavel pela criação da tela eventos de forma
/// dinamica, dividindo as classes em Todas, Aberto e Concluido
/// com o uso da class [EventCard] que mostra os eventos de forma
/// simplificada em cards

class EventsScreen extends StatefulWidget {
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin {
  var provider = new ShiftApiProvider();
  Strings strings = Strings();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: CustomTheme.shift().primaryColor,
          labelColor: Colors.grey,
          tabs: [
            Tab(text: strings.titles.get("all")),
            Tab(text: strings.titles.get("opened")),
            Tab(text: strings.titles.get("done")),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            RefresherList(
              item: (item) {
                return EventCard(message: item);
              },
              provider: (int page) {
                return provider.getMessagesPaginated("TODAS", 10, page);
              },
              textNoItems: strings.eventScreen.get("message_empty"),
            ),
            RefresherList(
              item: (item) {
                return EventCard(message: item);
              },
              provider: (int page) {
                return provider.getMessagesPaginated("ABERTAS", 10, page);
              },
              textNoItems: strings.eventScreen.get("message_empty_opened"),
            ),
            RefresherList(
              item: (item) {
                return EventCard(message: item);
              },
              provider: (int page) {
                return provider.getMessagesPaginated("FECHADAS", 10, page);
              },
              textNoItems: strings.eventScreen.get("message_empty_done"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
