import 'package:flutter/material.dart';

class BoardListScreen extends StatefulWidget {
  final int carNum;
  BoardListScreen({Key key, @required this.carNum}) : super(key: key);

  @override
  _BoardListScreenState createState() => _BoardListScreenState(carNum);
}

class _BoardListScreenState extends State<BoardListScreen> {
  int carNum;
  _BoardListScreenState(this.carNum);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carNum.toString() + "호 차량"),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            _currentBoard(context),
            _notBoard(context),
            _endBoard(context),
          ],
        ),
      ),
    );
  }

  Widget _currentBoard(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _sectionTitle(context, "현재 탑승목록"),

        ],
      ),
    );
  }

  Widget _notBoard(BuildContext context) {
    return Container(
      height: 200.0,
      child: Row( // 나머지 두 부분
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _sectionTitle(context, "금일 미탑승"),
                ListTile(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                _sectionTitle(context, "미확인"),
                ListTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _endBoard(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: FlatButton(
          color: Colors.yellow,
          child: Text("운행 종료"),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Container(  // 현재탑승목록 부분
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
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
