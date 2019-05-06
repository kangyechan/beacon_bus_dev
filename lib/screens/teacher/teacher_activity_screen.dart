import 'dart:async';

import 'package:beacon_bus/blocs/login/login_bloc.dart';
import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class TeacherActivityScreen extends StatefulWidget {
  final String className;

  TeacherActivityScreen({Key key, this.className}) : super(key: key);

  @override
  _TeacherActivityScreenState createState() => _TeacherActivityScreenState(className: className);
}

class _TeacherActivityScreenState extends State<TeacherActivityScreen> {
  final String className;
  _TeacherActivityScreenState({this.className});

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String dropdownDistanceValue;
  List<String> distanceList = ['10 M', '15 M', '20 M', '25 M', '30 M', '35 M', '40 M', '45 M', '50 M', '60 M', '70 M', '80 M', '90 M', '100 M'];
  int activityDistance = 20;
  String activityState = "in";
  String activityStateTitle = "현재 범위 내";
  int rangeIn;
  int rangeOut;

  @override
  void initState() {
    super.initState();
    _getCount("in");
    _getCount("out");
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('승하차 알림'),
        content: Text('$payload'),
      ),
    );
  }
  showNotification(String stateAlarm) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, '승하차 알림', stateAlarm, platform,
        payload: stateAlarm);
  }

  void _getCount(String activityState) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Children')
        .where('classRoom', isEqualTo: className)
        .where('activityState', isEqualTo: activityState)
        .snapshots().listen((data) {
      setState(() {
        if(activityState == "in") {
          rangeIn = data.documents.length;
        } else {
          rangeOut = data.documents.length;
        }
      });
    });
  }

  void _setStateChanged(String boardStateName) {
    setState(() {
      if(boardStateName == '범위 내') {
        activityState = "in";
        activityStateTitle = "현재 범위 내";
      } else {
        activityState = "out";
        activityStateTitle = "현재 범위 밖";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);

    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppbar(),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              _buildStateSection(),
              _buildBoardSection(),
              _buildEndBoard(),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return Future(() => false);
      },
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text(
        SCHOOL_NAME+" "+className+"반",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFC9EBF7),
    );
  }

  Widget _buildStateSection() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
      child: Row(
        children: <Widget>[
          _buildState(Icon(Icons.check_circle), Colors.green, "범위 내", rangeIn),
          _buildState(Icon(Icons.cancel), Colors.red, "범위 밖", rangeOut),
          _buildDistanceButton(),
        ],
      ),
    );
  }

  Widget _buildState(Icon stateIcon, Color stateColor, String name, int count){
    return Flexible(
      flex: 1,
      child: FlatButton(
        padding: EdgeInsets.all(5.0),
        onPressed: () {
          _setStateChanged(name);
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconTheme(
                data: IconThemeData(
                  color: stateColor,
                ),
                child: stateIcon,
              ),
            ),
            Text(
              name+ " "+count.toString()+"명",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceButton() {
    return Flexible(
      flex: 1,
      child: Center(
        child: DropdownButton(
          value: dropdownDistanceValue,
          onChanged: (String value) {
            setState(() {
              dropdownDistanceValue = value;
            });
          },
          items: distanceList.map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          )).toList(),
          hint: Text("범위 지정"),
        ),
      ),
    );
  }

  Widget _buildTitleSection(double width, String title) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFC9EBF7),
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBoardSection() {
    return Flexible(
      flex: 3,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _buildTitleSection(200.0, activityStateTitle),
          Flexible(
            child: _buildBoardMember(),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardMember() {
    return StreamBuilder(
        stream:  Firestore.instance
            .collection('Kindergarden')
            .document('hamang')
            .collection('Children')
            .where('classRoom', isEqualTo: className)
            .where('activityState', isEqualTo: activityState)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildMemberList(context, snapshot.data.documents);
        }
    );
  }

  Widget _buildMemberList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(10.0),
      childAspectRatio: 8.0 / 8.0,
      children: snapshot.map((data) => _buildMemberListItem(context, data)).toList(),
    );
  }

  Widget _buildMemberListItem(BuildContext context, DocumentSnapshot data) {
    final children = Children.fromSnapshot(data);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: AssetImage('images/adddefault.JPG'),
              ),
            ),
            Container(
              height: 40.0,
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        children.name,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    _buildStateIcon(children.activityState),
                  ],
                ),
                onPressed: () {
                  _changeState(children.id, children.name, children.activityState);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIcon(String boardState) {
    if(boardState == 'in') {
      return IconTheme(
        data: IconThemeData(
          color: Colors.green,
        ),
        child: Icon(
          Icons.check_circle,
          size: 20.0,
        ),
      );
    } else {
      return IconTheme(
        data: IconThemeData(
          color: Colors.red,
        ),
        child: Icon(
          Icons.cancel,
          size: 20.0,
        ),
      );
    }
  }

  Widget _buildEndBoard() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        color: Color(0xFFC9EBF7),
        child: Text(
          "활동 종료",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          _showCheckDialog();
        },
      ),
    );
  }

  void _changeStateSave(String id, String name, String currentState, String state) {
    if (currentState != state) {
      Firestore.instance
          .collection('Kindergarden')
          .document('hamang')
          .collection('Children')
          .document(id).updateData({
        'activityState': state,
        'changeStateTime': DateFormat('yyyy-MM-dd hh:mm')
            .format(DateTime.now())
            .toString(),
      });
      if (state == 'in') {
        showNotification(name + '이 범위 안에 들어왔습니다.');
      } else {
        showNotification(name + '이 범위를 이탈했습니다.');
      }
    }
    Navigator.of(context).pop();
  }

  void _changeState(String id, String name, String currentState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "상태 변경",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("현재 상태를 변경합니다."),
          actions: <Widget>[
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      "범위 내",
                      style: TextStyle(
                        color: Color(0xFF1EA8E0),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _changeStateSave(id, name, currentState, 'in');
              },
            ),
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.cancel,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      "범위 밖",
                      style: TextStyle(
                        color: Color(0xFF1EA8E0),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _changeStateSave(id, name, currentState, 'out');
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "활동 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("모든 학생의 상태를 확인하셨나요?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인완료",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                if(rangeOut > 0){
                  Navigator.of(context).pop();
                  _showStateCheckDialog(rangeOut);
                } else {
                  Navigator.of(context).pop();
                  _showCloseDialog();
                }
              },
            ),
            CupertinoButton(
              child: Text(
                "아니오",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
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

  void _showStateCheckDialog(int count) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "종료 실패",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
                count.toString() + "명이 범위 밖에 있습니다.\n"
                    "인원을 확인해주세요."
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "인원 확인",
                  style: TextStyle(
                    color: Color(0xFF1EA8E0),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  void _showCloseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "활동 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("활동을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "활동 종료",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
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
}
