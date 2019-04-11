import 'dart:async';

import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/screens/teacher/teacher_activity_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_bus_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {

  Future<FirebaseUser> get user => FirebaseAuth.instance.currentUser();

  final List<String> _busNumber = ["1호차", "2호차", "3호차", "4호차", "5호차", "6호차"];
  String dropdownValue;
  String className;
  int carNum;

  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);
    return Scaffold(
      appBar: _buildAppbar(),
      drawer: Drawer(
        child: _buildDrawer(bloc),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                SizedBox(height: 10.0,),
                _teacherName(),
                _buildReadMe(),
                SizedBox(height: 10.0,),
                _buildDropdownButton(),
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
      title: Text(
        "소담 어린이집",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }
  Widget _buildDrawer(LoginBloc bloc) {
    return Column(
        children: <Widget>[
          _buildUserAccounts(),
          _buildDrawerList(),
          _divider(),
          _logoutDrawer(bloc),
        ],
    );
  }
  Widget _buildUserAccounts() {
    return Container(
      height: 200.0,
      child: UserAccountsDrawerHeader(
        margin: EdgeInsets.all(0.0),
        accountName: Text(
          "강예찬 선생님",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        accountEmail: Text(
          "소담유치원 연두별반",
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            "T",
          ),
        ),
      ),
    );
  }
  Widget _buildDrawerList() {
    return Expanded(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "야외활동",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.navigate_next,
            ),
            onTap: () {
              _buildActivityCheck();
            },
          ),
          _divider(),
          ListTile(
            title: Text(
              "승하차 기록",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/teacherlog');
            },
          ),
          _divider(),
        ],
      ),
    );
  }
  Widget _logoutDrawer(LoginBloc bloc) {
    return  ListTile(
      title: Text(
        "로그아웃",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        bloc.signOut();
      },
    );
  }
  void _buildActivityCheck() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "야외활동 신호측정",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("야외활동 신호측정을 시작하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherActivityScreen(className: className,)
                  ),
                );
              },
            ),
            FlatButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _teacherName() {
    return Flexible(
      flex: 2,
      child: Center(
        child: Container(
          width: 150.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.yellow,
                width: 2.0,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              "강예찬 선생님",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildReadMe() {
    return Flexible(
      flex: 1,
      child: Text(
          "탑승할 차량 번호를 선택하고\n"
          "운행시작 버튼을 눌러주세요.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
    );
  }
  Widget _buildDropdownButton() {
    return  Flexible(
      flex: 1,
      child: Center(
        child: DropdownButton(
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
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, int carNum) {
    return Flexible(
      flex: 1,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "운행시작",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.yellow,
        onPressed: () {
          if(carNum == null) {
            _selectCarNum();
          } else {
            _startCheck(carNum);
          }
        },
      ),
    );
  }
  void _selectCarNum() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "운행 차량 선택",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("탑승하는 차량을 확인해 주세요."),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _startCheck(int carNum) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "운행 시작",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(carNum.toString() + "호차 운행을 시작하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "운행 시작",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherBusScreen(carNum: carNum,)
                  ),
                );
              },
            ),
            FlatButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'images/background.JPG',
      fit: BoxFit.fitWidth,
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.5,
      color: Colors.yellow,
    );
  }
}
