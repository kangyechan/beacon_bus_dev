import 'package:flutter/material.dart';


class TeacherLogScreen extends StatefulWidget {
  final int carNum;

  const TeacherLogScreen({Key key, this.carNum}): super(key: key);

  @override
  _TeacherLogScreenState createState() => _TeacherLogScreenState(carNum: carNum);
}

class _TeacherLogScreenState extends State<TeacherLogScreen> {
  final int carNum;

  _TeacherLogScreenState({this.carNum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("로그"),
      ),
    );
  }
}
