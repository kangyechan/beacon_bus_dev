import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  int boarding = 3;
  int notBoarding = 1;
  int unKnown = 0;

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
      backgroundColor: Colors.yellow,
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
      child: Flex(
        direction: Axis.horizontal,
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
    );
  }
  Widget _buildTitleSection(double width, String title) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.yellow,
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
          _buildTitleSection(200.0, "현재 탑승 상태"),
          Flexible(
            child: _buildBoardMember(),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardMember() {
    return StreamBuilder(
      stream:  Firestore
          .instance
          .collection('Kindergarden')
          .document('hamang')
          .collection('Children')
          .where('busNum', isEqualTo: carNum.toString())
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
      key: ValueKey(children.phoneNumber),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
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
            Expanded(
              child: ListTile(
                title: Text(
                  children.name,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                trailing: _buildStateIcon(children.boardState),
                onTap: () {
                  _changeState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIcon(bool boardState) {
    // notBoardingDate가 없을때 조건도 추가해야함.
   if(boardState) {
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
        color: Colors.yellow,
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

  void _changeState() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "상태 변경",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("현재 상태를 변경하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "탑승중",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "미탑승",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "개인이동",
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
  void _showCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "운행 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("모든 학생의 상태를 확인하셨나요?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "확인완료",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showCloseDialog();
              },
            ),
            FlatButton(
              child: Text(
                "아니오",
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
  void _showCloseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "운행 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("운행을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "운행 종료",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
}
