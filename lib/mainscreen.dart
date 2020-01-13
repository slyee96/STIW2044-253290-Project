import 'package:flutter/material.dart';
import 'tapscreen.dart';
import 'tapscreen2.dart';
import 'tapscreen3.dart';
import 'tapscreen4.dart';
import 'user.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.orange[50],
          selectedItemBorderColor: Colors.white,
          selectedItemBackgroundColor: Colors.orange,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: currentTabIndex,
        onSelectTab: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.search,
            label: 'Search',
          ),
          FFNavigationBarItem(
            iconData: Icons.list,
            label: 'Posted Fish',
          ),
          FFNavigationBarItem(
            iconData: Icons.event,
            label: 'Order Fish',
          ),
          FFNavigationBarItem(
            iconData: Icons.person,
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
