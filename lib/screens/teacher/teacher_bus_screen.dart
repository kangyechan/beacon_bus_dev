import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
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


  String boardingState = "board";
  String boardingStateTitle = "현재 탑승 명단";
  int boarding;
  int notBoarding;
  int unKnown;

  @override
  void initState() {
    super.initState();
    _getCount("board");
    _getCount("unknown");
    _getCount("notboard");

  }

  void _getCount(String boardingState) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Children')
        .where('busNum', isEqualTo: carNum.toString())
        .where('boardState', isEqualTo: boardingState)
        .snapshots().listen((data) {
      setState(() {
        if(boardingState == "board") {
          boarding = data.documents.length;
        } else if(boardingState == "unknown") {
          unKnown = data.documents.length;
        } else {
          notBoarding = data.documents.length;
        }
      });
    });
  }
  void _setStateChanged(String boardStateName) {
    setState(() {
      if(boardStateName == '탑승중') {
        boardingState = "board";
        boardingStateTitle = "현재 탑승 명단";
      } else if(boardStateName == '미탑승') {
        boardingState = "unknown";
        boardingStateTitle = "현재 미탑승 명단";
      } else {
        boardingState = "notboard";
        boardingStateTitle = "금일 개인이동 명단";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
    return Padding(
        padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
        child: Row(
          children: <Widget>[
            _buildState(Icon(Icons.check_circle), Colors.green, "탑승중", boarding),
            _buildState(Icon(Icons.cancel), Colors.red, "미탑승", unKnown),
            _buildState(Icon(Icons.error), Colors.orange, "개인이동", notBoarding),
          ],
        )
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
            Text(name+ " "+count.toString()+"명"),
          ],
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
              child: Image(
                image: AssetImage('images/adddefault.JPG'),
              ),
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
                  _changeState(children.id, children.boardState);
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

  Widget _buildEndBoard() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        color: Color(0xFFC9EBF7),
        child: Text(
          "운행 종료",
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

  void _changeStateSave(String id, String currentState, String state) {
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
    }
    Navigator.of(context).pop();
  }

  void _changeState(String id, String currentState) {
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
              onPressed: () {
                _changeStateSave(id, currentState, 'board');
              },
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
                _changeStateSave(id, currentState, 'unknown');
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
                _changeStateSave(id, currentState, 'notboard');
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
                if(boarding > 0){
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
                count.toString() + "명이 탑승중 입니다.\n"
                    "차량을 확인해주세요."
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "차량 확인",
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
          content: Text("운행을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "운행 종료",
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
