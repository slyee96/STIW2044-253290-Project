import 'package:flutter/material.dart';
import 'tapscreen.dart';
import 'tapscreen2.dart';
import 'tapscreen3.dart';
import 'tapscreen4.dart';
import 'user.dart';

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

  String $pagetitle = "myNelayan";
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.orange[100],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Main Page'),
        ),
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          //backgroundColor: Colors.blueGrey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Fish"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              title: Text("Posted Fish"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text("Order Fish"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text("Account"),
            )
          ],
        ),
      ),
    );
  }
}
