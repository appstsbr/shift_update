import 'package:flutter/material.dart';

/// class [RefresherListSimple] responsavel como tela de espera ate que os dados
/// sejam carregados em tela
class RefresherListSimple extends StatefulWidget {
  final Function onRefresh;
  final Function(dynamic item) itemBuiler;
  final String textNoItems;
  RefresherListSimple(
      {Key? key,
      required this.onRefresh,
      required this.itemBuiler,
      this.textNoItems = "No items"})
      : super(key: key);

  @override
  _RefresherListSimpleState createState() => _RefresherListSimpleState();
}

class _RefresherListSimpleState extends State<RefresherListSimple> {
  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: isLoading ? loading() : listView(),
      ),
    );
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true;
    });
    var data;
    try {
      data = await widget.onRefresh();
    } catch (e) {
      print(e);
      data = [];
    }

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  Widget listView() {
    return items.length != 0
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.itemBuiler(items[index]);
            },
          )
        : noItems();
  }

  Widget noItems() {
    return Center(child: Text(widget.textNoItems));
  }

  Widget loading() {
    return Center(child: CircularProgressIndicator());
  }
}
