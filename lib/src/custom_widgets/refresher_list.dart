import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';
import 'package:shift_flutter/src/helpers/custom_controller.dart';
import 'package:shift_flutter/src/models/paginated.dart';

/// class [RefresherList] responsavel como tela de espera ate que os dados
/// sejam carregados em tela
class RefresherList extends StatefulWidget {
  final item;
  final provider;
  final String? textNoItems;
  final CustomController? controller;

  const RefresherList(
      {super.key,
      required this.item,
      required this.provider,
      this.textNoItems = "No Items",
      this.controller});

  _RefresherListState createState() => _RefresherListState();
}

class _RefresherListState extends State<RefresherList> {
  int _page = 1;
  bool _noMoreItems = false;
  late ScrollController _control;
  late List _items;
  late bool _isRefreshing;
  @override
  void initState() {
    super.initState();
    _control = new ScrollController();
    _control.addListener(_checkEndScroll);
    _items = [];
    _isRefreshing = false;
    _getItems();
    if (widget.controller != null) {
      widget.controller!.add("refresh", _refreshItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.length > 0)
      return RefreshIndicator(
        color: CustomTheme.shift().primaryColor,
        onRefresh: _refreshItems,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _control,
          itemCount: _items.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _items.length) {
              if (_isRefreshing)
                return progress();
              else
                return Text("");
            }
            return widget.item(_items[index]);
          },
        ),
      );
    else if (_isRefreshing)
      return progress();
    else
      return Stack(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Center(child: Text(widget.textNoItems ?? "No Items"))),
          )),
          RefreshIndicator(
            color: CustomTheme.shift().primaryColor,
            child: ListView(),
            onRefresh: _refreshItems,
          ),
        ],
      );
  }

  Widget progress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
                CustomTheme.shift().primaryColor)),
      ],
    );
  }

  void _checkEndScroll() {
    if (_control.offset >= _control.position.maxScrollExtent &&
        !_control.position.outOfRange) {
      _getItems();
    }
  }

  void _getItems() async {
    if (!_noMoreItems & !_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });
      late Paginated paging;
      try {
        paging = await widget.provider(_page);
        List items = paging.data;
        if (items.length == 0) {
          setState(() {
            _noMoreItems = true;
            _isRefreshing = false;
          });
          return;
        }
        List old = [];

        old.addAll(_items);
        old.addAll(items);
        setState(() {
          _items = old;
          _page++;
          _isRefreshing = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _refreshItems() async {
    if (!_isRefreshing) {
      setState(() {
        _items = [];
        _page = 1;
        _noMoreItems = false;
        _isRefreshing = true;
      });

      late Paginated paging;
      try {
        paging = await widget.provider(_page);
      } catch (e) {
        setState(() {
          _isRefreshing = false;
        });
        print(e);
      }
      _page++;
      setState(() {
        _isRefreshing = false;
        _items = paging.data;
      });
    }
  }
}
