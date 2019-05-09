import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/screens/teacher/teacher_activitylog_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_buslog_screen.dart';
import 'package:flutter/material.dart';
import '../../blocs/login/login_provider.dart';

class TeacherLogScreen extends StatefulWidget {
  @override
  _TeacherLogScreenState createState() => _TeacherLogScreenState();
}

class _TeacherLogScreenState extends State<TeacherLogScreen> {
  List<Widget> pages;
  int _currentIndex = 0;
  Widget currentPage;

  TeacherBusLogScreen teacherBusLogScreen;
  TeacherActivityLogScreen teacherActivityLogScreen;

  @override
  void initState() {
    super.initState();
    teacherBusLogScreen = TeacherBusLogScreen();
    teacherActivityLogScreen = TeacherActivityLogScreen();
    pages = [teacherBusLogScreen, teacherActivityLogScreen];
    currentPage = teacherBusLogScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: buildBarItems(),
        fixedColor: Color(0xFF1EA8E0),
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        SCHOOL_NAME+" 활동기록",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFFC9EBF7),
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
    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_bus), title:  Text("승하차 기록", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(icon: Icon(Icons.directions_run), title:  Text("야외활동 기록", style: TextStyle(fontSize: 12.0))));
    return list;
  }
}