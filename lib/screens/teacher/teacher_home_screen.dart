import 'package:beacon_bus/screens/teacher/teacher_activity_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_bus_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_log_screen.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _currentIndex = 0;
  TeacherBusScreen teacherBusScreen;
  TeacherActivityScreen teacherActivityScreen;
  TeacherLogScreen teacherLogScreen;

  Widget currentPage;

  List<Widget> pages;

  @override
  void initState() {
    super.initState();

    teacherBusScreen = TeacherBusScreen();
    teacherActivityScreen = TeacherActivityScreen();
    teacherLogScreen = TeacherLogScreen();

    pages = [teacherBusScreen, teacherActivityScreen, teacherLogScreen];
    currentPage = teacherBusScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("소담 어린이집"),
        centerTitle: true,
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

    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_bus), title: Text("버스", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_run), title: Text("야외", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.note), title: Text("로그", style: TextStyle(fontSize: 12.0))));

    return list;
  }
}