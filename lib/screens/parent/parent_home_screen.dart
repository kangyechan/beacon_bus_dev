import 'package:flutter/material.dart';
import 'board_status_screen.dart';
import 'board_yes_or_no.screen.dart';
import 'board_record_screen.dart';
import '../../blocs/login/login_provider.dart';

class ParentHomeScreen extends StatefulWidget {
  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  List<Widget> pages;
  int _currentIndex = 0;
  Widget currentPage;

  BoardStatusScreen boardStatusScreen;
  BoardYesOrNoScreen boardYesOrNoScreen;
  BoardRecordScreen boardRecordScreen;

  @override
  void initState() {
    super.initState();
    boardStatusScreen = BoardStatusScreen();
    boardYesOrNoScreen = BoardYesOrNoScreen();
    boardRecordScreen = BoardRecordScreen();
    pages = [boardStatusScreen, boardYesOrNoScreen, boardRecordScreen];
    currentPage = boardStatusScreen;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("유치원 어플"),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: bloc.signOut),
        backgroundColor: Colors.yellow,
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: buildBarItems(),
        fixedColor: Colors.yellow,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      currentPage = pages[index];
    });
  }

  List<BottomNavigationBarItem> buildBarItems() {
    final List<BottomNavigationBarItem> list = [];
    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_bus), title:  Text("승하차 상태", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_run), title:  Text("탑승유무", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.note), title:  Text("기록", style: TextStyle(fontSize: 12.0))));
    return list;
  }
}