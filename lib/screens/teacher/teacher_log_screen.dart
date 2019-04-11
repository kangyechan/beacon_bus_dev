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
      appBar: _buildAppbar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            _inCheck(),
            SizedBox(width: 20.0,),
            _outCheck(),
          ],
        )
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
        "소담 어린이집",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _inCheck() {
    return Flexible(
      flex: 1,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _checkTitleSection("승차"),
          _checkSubSection(),
          Flexible(
            child: ListView(
              children: <Widget>[
                _buildLogSection(),
              ],
            ),
          ),
        ],
      )
    );
  }
  Widget _outCheck() {
    return Flexible(
        flex: 1,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            _checkTitleSection("하차"),
            _checkSubSection(),
            Flexible(
              child: ListView(
                children: <Widget>[
                  _buildLogSection(),
                ],
              ),
            ),
          ],
        )
    );
  }
  Widget _checkTitleSection(String title) {
    return Center(
      child: Container(
        width: 70.0,
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.yellow,
              width: 2.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  Widget _checkSubSection() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _buildSubSection("날짜"),
          ),
          Flexible(
            flex: 1,
            child: _buildSubSection("이름"),
          ),
          Flexible(
            flex: 1,
            child: _buildSubSection("시간"),
          ),
        ],
      ),
    );
  }
  Widget _buildSubSection(String subtitle) {
    return Center(
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  Widget _buildLogSection() {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Center(
            child: Text("4월 11일"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Text("강예찬"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Text("3시 20분"),
          ),
        ),
      ],
    );
  }
}
