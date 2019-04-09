import 'package:beacon_bus/screens/teacher/teacher_board_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_log_screen.dart';
import 'package:flutter/material.dart';

class TeacherBusScreen extends StatefulWidget {
  final int carNum;

  TeacherBusScreen({Key key, this.carNum}): super(key: key);

  @override
  _TeacherBusScreenState createState() => _TeacherBusScreenState(carNum: carNum);
}

class _TeacherBusScreenState extends State<TeacherBusScreen> {
  final int carNum;

  _TeacherBusScreenState({this.carNum});

  int _currentIndex = 0;
  TeacherBoardScreen teacherBoardScreen;
  TeacherLogScreen teacherLogScreen;

  Widget currentPage;

  List<Widget> pages;

  @override
  void initState() {
    super.initState();

    teacherBoardScreen = TeacherBoardScreen(carNum: carNum);
    teacherLogScreen = TeacherLogScreen();

    pages = [teacherBoardScreen, teacherLogScreen];
    currentPage = teacherBoardScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: currentPage,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text("소담 어린이집 " + carNum.toString() + " 호차"),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: buildBarItems(),
      fixedColor: Colors.yellow,
      currentIndex: _currentIndex,
      onTap: onTabTapped,
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

    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_bus), title: Text("버스", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.note), title: Text("로그", style: TextStyle(fontSize: 12.0))));

    return list;
  }
}