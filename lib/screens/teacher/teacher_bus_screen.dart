import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:beacon_bus/screens/teacher/widgets/alarm.dart';
import 'package:beacon_bus/screens/beacon/tab_ranging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherBusScreen extends StatefulWidget {
  final int carNum;

  TeacherBusScreen({Key key, this.carNum}): super(key: key);

  @override
  _TeacherBusScreenState createState() => _TeacherBusScreenState(carNum: carNum);
}

class _TeacherBusScreenState extends State<TeacherBusScreen> {
  final int carNum;
  _TeacherBusScreenState({this.carNum});

  Alarm alarm = new Alarm();

  String boardingState = "board";
  String boardingStateTitle = "현재 탑승중";
  int busSize;
  int boarding;
  int notBoarding;
  int unKnown;

  @override
  void initState() {
    super.initState();
    _setDistance();
    _setNotBoard();

  }

  void _setDistance() {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Bus')
        .where('number', isEqualTo: carNum)
        .snapshots()
        .listen((data) =>
    busSize = int.parse(data.documents[0]['distance']
    ));
  }

  void _setNotBoard() {
//    Firestore.instance
//        .collection('Kindergarden')
//        .document('hamang')
//        .collection('Children')
//        .where('number', isEqualTo: carNum)
//        .snapshots()
//        .listen((data) =>
//
//    busSize = int.parse(data.documents[0]['number']
//    ));
  }

  void _setStateChanged(String boardStateName) {
    setState(() {
      if(boardStateName == '탑승중') {
        boardingState = "board";
        boardingStateTitle = "현재 탑승중";
      } else if(boardStateName == '미탑승') {
        boardingState = "unknown";
        boardingStateTitle = "현재 미탑승중";
      } else {
        boardingState = "notboard";
        boardingStateTitle = "오늘 개인이동";
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
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text(
        SCHOOL_NAME +" "+carNum.toString()+"호 차량",
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
          Flexible(flex: 1, child: _buildState(Icon(Icons.check_circle), Colors.green, "탑승중")),
          Flexible(flex: 1, child: _buildState(Icon(Icons.cancel), Colors.red, "미탑승")),
          Flexible(flex: 1, child: _buildState(Icon(Icons.error), Colors.orange, "개인이동")),
        ],
      ),
    );
  }

  Widget _buildState(Icon stateIcon, Color stateColor, String name) {
    Widget countSection;
    if (name == "탑승중") {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('busNum', isEqualTo: carNum.toString())
              .where('boardState', isEqualTo: 'board')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            boarding = snapshot.data.documents.length;
            return _countSectionContents(
                stateIcon, stateColor, name, boarding);
          }
      );
    } else if (name == '미탑승') {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('busNum', isEqualTo: carNum.toString())
              .where('boardState', isEqualTo: 'unknown')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            unKnown = snapshot.data.documents.length;
            return _countSectionContents(stateIcon, stateColor, name, unKnown);
          }
      );
    } else {
      countSection = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Kindergarden')
              .document('hamang')
              .collection('Children')
              .where('busNum', isEqualTo: carNum.toString())
              .where('boardState', isEqualTo: 'notboard')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            notBoarding = snapshot.data.documents.length;
            return _countSectionContents(stateIcon, stateColor, name, notBoarding);
          }
      );
    }
    return countSection;
  }

  Widget _countSectionContents(Icon stateIcon, Color stateColor,
      String name, int count){
    return FlatButton(
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
          _buildTitleSection(200.0, boardingStateTitle),
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
            .where('busNum', isEqualTo: carNum.toString())
            .where('boardState', isEqualTo: boardingState)
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
              child: children.profileImageUrl == '' ?
                Image(image: AssetImage('images/profiledefault.png'), fit: BoxFit.fitHeight,)
                : Image.network(children.profileImageUrl, fit: BoxFit.fitHeight,),
            ),
            Container(
              height: 30.0,
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
                    _buildStateIcon(children.boardState),
                  ],
                ),
                onPressed: () {
                  _changeState(children.id, int.parse(children.beaconMajor), children.name, children.boardState);
                },
              ),
            ),
            Center(
              child: Text(
                children.protector + "가 기다려요",
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIcon(String boardState) {
    // notBoardingDate가 없을때 조건도 추가해야함.
    if(boardState == 'board') {
      return IconTheme(
        data: IconThemeData(
          color: Colors.green,
        ),
        child: Icon(
          Icons.check_circle,
          size: 20.0,
        ),
      );
    } else if(boardState == 'unknown') {
      return IconTheme(
        data: IconThemeData(
          color: Colors.red,
        ),
        child: Icon(
          Icons.cancel,
          size: 20.0,
        ),
      );
    } else {
      return IconTheme(
        data: IconThemeData(
          color: Colors.amber,
        ),
        child: Icon(
          Icons.error,
          size: 20.0,
        ),
      );
    }
  }

  Widget _buildButtonSection() {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: RangingTab(carNum.toString(), '', busSize),
            ),
          ),
          Expanded(
            child: Center(
              child: FlatButton(
                color: Color(0xFFC9EBF7),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "운행 종료",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  print(busSize);
                  _showCheckDialog();
                },
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
        'boardState': state,
        'changeStateTime': DateFormat('yyyy-MM-dd hh:mm')
            .format(DateTime.now())
            .toString(),
      });
      if (state == 'board') {
        alarm.showNotification(major, name + '이 승차했습니다.');
      } else if (state == 'notboard') {
        alarm.showNotification(major, name + '이 개인이동 합니다.');
      } else {

        alarm.showNotification(major, name + '이 하차했습니다.');
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
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "탑승중",
                      style: TextStyle(
                        color: Color(0xFF1EA8E0),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () =>  _changeStateSave(id, major, name, currentState, 'board'),
            ),
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.cancel,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "미탑승",
                      style: TextStyle(
                        color: Color(0xFF1EA8E0),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _changeStateSave(id, major, name, currentState, 'unknown');
              },
            ),
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.amber,
                      ),
                      child: Icon(
                        Icons.error,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "개인이동",
                      style: TextStyle(
                        color: Color(0xFF1EA8E0),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _changeStateSave(id, major, name, currentState, 'notboard');
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
            "운행 종료",
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
                if(boarding > 0) {
                  Navigator.of(context).pop();
                  _showStateCheckDialog(boarding);
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
            title: Text(
              "종료 실패",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
                "\n"+ count.toString() + "명이 탑승중 입니다.\n"
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
            "운행 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("\n이상이 없습니다.\n운행을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                _setBusTeacherName('', carNum);
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
  _setBusTeacherName(String teacherName, int busNum) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Bus')
        .document(busNum.toString()+'호차').updateData({
      'teacher': teacherName,
    });
  }
}
