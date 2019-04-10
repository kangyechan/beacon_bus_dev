import 'package:beacon_bus/blocs/teacher/teacher_provider.dart';
import 'package:beacon_bus/screens/teacher/teacher_bus_screen.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {

  final List<String> _busNumber = ["1호차", "2호차", "3호차", "4호차", "5호차", "6호차"];
  String dropdownValue;
  int carNum;

  @override
  Widget build(BuildContext context) {
    final bloc = TeacherProvider.of(context);

    return Scaffold(
      appBar: _buildAppbar(),
      drawer: Drawer(
        child: _buildDrawer(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100.0),
                _buildDropdownButton(),
                SizedBox(height: 30.0),
                _buildButton(context, carNum),
              ],
            ),
          ),
          Expanded(
            child: _buildBackground(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text("소담 어린이집"),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _buildDrawer() {
    return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _buildUserAccounts(),
          _buildDrawerList(),
          _logoutDrawer(),
        ],
    );
  }

  Widget _buildUserAccounts() {
    return Flexible(
      flex: 2,
      child: UserAccountsDrawerHeader(
        accountName: Text("강예찬 선생님"),
        accountEmail: Text("소담유치원 연두별반"),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            "A",
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerList() {
    return Flexible(
      flex: 4,
      child: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("야외활동"),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                print("Item tap");
              },
            ),
            ListTile(
              title: Text("수신기록"),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                print("Item tap");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutDrawer() {
    return Flexible(
      flex: 1,
      child: ListTile(
        title: Text("로그아웃"),
        onTap: () {
          print("Item tap");
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, int carNum) {
    return FlatButton(
      child: Text("운행시작"),
      color: Colors.yellow,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherBusScreen(carNum: carNum,)
          ),
        );
      },
    );
  }

  Widget _buildDropdownButton() {
    return  DropdownButton(
      value: dropdownValue,
      onChanged: (String value) {
        setState(() {
          dropdownValue = value;
          carNum = _busNumber.indexWhere((num) => num.startsWith(value)) + 1;
        });
      },
      items: _busNumber.map((value) => DropdownMenuItem(
        value: value,
        child: Text(value),
      )).toList(),
      hint: Text("운행 차량"),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'images/background.JPG',
    );
  }
}
