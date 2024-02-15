import 'package:flutter/material.dart';

/// class [TPageview] responsavel pela navegação entre as telas
/// Notificação, Chats, Eventos e Perfil
class TPageview extends StatefulWidget {
  final List<Widget>? pages;
  final List<BottomNavigationBarItem>? bottomNavigationBarItem;
  final Color? selectedItemColor;
  final Function(int prev, int next)? onPageChange;

  TPageview({
    Key? key,
    this.pages,
    this.bottomNavigationBarItem,
    this.selectedItemColor,
    this.onPageChange,
  }) : super(key: key);

  @override
  _TPageviewState createState() => _TPageviewState();
}

class _TPageviewState extends State<TPageview>
    with SingleTickerProviderStateMixin {
  bool isSearchEnable = false;
  TextEditingController searchController = TextEditingController();
  late TabController tabController;
  late int _selectedIndex;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: widget.pages!.length);
    _selectedIndex = 0;
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    Color selectedItemColor;
    if (widget.selectedItemColor == null)
      selectedItemColor = Theme.of(context).primaryColor;
    else
      selectedItemColor = widget.selectedItemColor!;
    return Scaffold(
      body: pageView(),
      bottomNavigationBar: bottomNavigationBar(selectedItemColor),
    );
  }

  void _onItemTPageviewed(int index) {
    setState(() {
      if (widget.onPageChange != null)
        widget.onPageChange!(_selectedIndex, index);
      _selectedIndex = index;
      pageController.animateToPage(index,
          curve: Curves.linear, duration: Duration(milliseconds: 100));
    });
  }

  Widget bottomNavigationBar(Color selectColor) {
    return BottomNavigationBar(
      items: widget.bottomNavigationBarItem!,
      currentIndex: _selectedIndex,
      selectedItemColor: selectColor,
      unselectedItemColor: Colors.black,
      onTap: _onItemTPageviewed,
    );
  }

  Widget pageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (page) {
        setState(() {
          if (widget.onPageChange != null)
            widget.onPageChange!(_selectedIndex, page);
          _selectedIndex = page;
        });
      },
      children: widget.pages!,
    );
  }
}
