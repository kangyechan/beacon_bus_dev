import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:beacon_bus/screens/beacon/tab_ranging.dart';
import 'package:beacon_bus/screens/teacher/widgets/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Alarm alarm = new Alarm();

  String dropdownDistanceValue = '5 M';
  int limitDistance = 5;
  List<String> distanceList = ['3 M', '5 M', '10 M', '15 M', '20 M', '25 M', '30 M'];
  String activityState = null;
  String activityStateTitle = "전체 인원";
  int total;
  int rangeIn;
  int rangeOut;

  Color totalColor = Color(0xFF1EA8E0);
  Color insideColor = Colors.white;
  Color outsideColor = Colors.white;
  Color IconColor = Colors.green;

  void _setStateChanged(String boardStateName) {
    setState(() {
      if(boardStateName == '전체') {
        activityState = null;
        activityStateTitle = "전체 인원";
        totalColor = Color(0xFF1EA8E0);
        insideColor = Colors.white;
        outsideColor = Colors.white;
      } else if(boardStateName == '범위 내') {
        activityState = "in";
        activityStateTitle = "지정범위 내";
        totalColor = Colors.white;
        insideColor = Color(0xFF1EA8E0);
        outsideColor = Colors.white;
      } else {
        activityState = "out";
        activityStateTitle = "지정범위 밖";
        totalColor = Colors.white;
        insideColor = Colors.white;
        outsideColor = Color(0xFF1EA8E0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppbar(),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  _buildStateSection(),
                  _buildBoardSection(),
                  _buildButtonSection(),
                ],
              ),
            ),
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
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(flex: 1, child: _buildState("전체", totalColor)),
          Flexible(flex: 1, child: _buildState("범위 내", insideColor)),
          Flexible(flex: 1, child: _buildState("범위 밖", outsideColor)),
          Flexible(flex: 1, child: _buildDistanceButton()),
        ],
      ),
    );
  }

  Widget _buildState(String name, Color color) {
    Widget countSection;
    if (name == "전체") {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('classRoom', isEqualTo: className)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            total = snapshot.data.documents.length;
            return _countSectionContents(name, total, color);
          }
      );
    } else if (name == "범위 내") {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('classRoom', isEqualTo: className)
              .where('activityState', isEqualTo: 'in')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            rangeIn = snapshot.data.documents.length;
            return _countSectionContents(name, rangeIn, color);
          }
      );
    } else {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('classRoom', isEqualTo: className)
              .where('activityState', isEqualTo: 'out')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            rangeOut = snapshot.data.documents.length;
            return _countSectionContents(name, rangeOut, color);
          }
      );
    }
    return countSection;
  }

  Widget _countSectionContents(String name, int count, Color color){
    return Container(
      margin: EdgeInsets.only(left: 5.0),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        borderSide: BorderSide(color: color, width: 2.0),
        padding: EdgeInsets.all(5.0),
        onPressed: () {
          _setStateChanged(name);
        },
        child: Text(
          name+ " "+count.toString()+"명",
        ),
      ),
    );
  }

  Widget _buildDistanceButton() {
    return Center(
      child: DropdownButton(
        value: dropdownDistanceValue,
        onChanged: (String value) {
          setState(() {
            dropdownDistanceValue = value;
            if(value.length == 3) {
              limitDistance = int.parse(value.substring(0,1));
              print(limitDistance);
            } else {
              limitDistance = int.parse(value.substring(0,2));
              print(limitDistance);
            }
          });
        },
        items: distanceList.map((value) => DropdownMenuItem(
          value: value,
          child: Container(
            margin: EdgeInsets.only(left: 15.0,),
            child: Text(value),
          ),
        )).toList(),
        hint: Text("범위 지정"),
      ),
    );
  }

  Widget _buildTitleSection(double width, String title) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF1EA8E0),
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
          _buildTitleSection(150.0, activityStateTitle),
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
    if(children.activityState == 'in') {
      IconColor = Colors.green;
    } else {
      IconColor = Colors.grey[300];
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: IconColor,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                child: children.profileImageUrl == ''
                    ? Image(image: AssetImage('images/profiledefault.png'), fit: BoxFit.fill,)
                    : Image.network(children.profileImageUrl, fit: BoxFit.fill,),
              ),
            ),
            Container(
              height: 40.0,
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: IconColor,
                      size: 15.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      children.name,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _changeState(children.id, int.parse(children.beaconMajor), children.name, children.activityState);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: RangingTab('', className, limitDistance),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    color: Color(0xFFC9EBF7),
                    padding: EdgeInsets.all(10.0),
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
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _changeStateSave(String id, int major, String name, String currentState, String state) {
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
        alarm.showNotification(major, name + '이 범위로 들어왔습니다.');
      } else {
        alarm.showNotification(major, name + '이 범위를 이탈했습니다.');
      }
    }
    Navigator.of(context).pop();
  }

  void _changeState(String id, int major, String name, String currentState) {
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
          content: Text("\n현재 상태를 변경합니다."),
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
                _changeStateSave(id, major, name, currentState, 'in');
              },
            ),
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: Colors.grey,
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
                _changeStateSave(id, major, name, currentState, 'out');
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
          content: Text("\n모든 학생을 확인하셨나요?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                if(rangeOut > 0) {
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
  void _showStateCheckDialog(int count) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(

            title: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "위험!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            content: Text(
                "\n" + count.toString() + "명이 범위 밖에 있습니다.\n"
                    "다시 한 번 확인해주세요."
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "확인",
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
            "측정 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("\n이상이 없습니다.\n활동을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인",
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
