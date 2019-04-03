import 'package:flutter/material.dart';

class BoardListScreen extends StatelessWidget {
  final int carNum;

  BoardListScreen({this.carNum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            _buildBoardSection(),
            SizedBox(height: 10.0),
            _buildNotBoardSection(),
            _buildEndBoard(),
          ],
        ),
      ),

    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text(carNum.toString() + "호 차량"),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _buildBoardSection() {
    return Flexible(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.yellow,
          )
        ),
        child: Flex(
          direction: Axis.vertical,
            children: <Widget>[
            _buildTitleSection(150.0, "현재 탑승목록"),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.yellow,
                      )
                  ),
                  child: ListView(
                    children: <Widget>[
                      ListTile(title: Text("강예찬"), trailing: Text("123"), onTap: () {print("name tap"); },),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNotBoardSection() {
    return Flexible(
      flex: 2,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          _buildNotBoard(),
          SizedBox(width: 10.0),
          _buildUnknownBoard(),
        ],
      ),
    );
  }
  Widget _buildEndBoard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.yellow,
        child: Text("운행 종료"),
        onPressed: () {

        },
      ),
    );
  }

  Widget _buildNotBoard() {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.yellow,
            )
        ),
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              _buildTitleSection(100.0, "미탑승"),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile(title: Text("강예찬"), trailing: Text("123"), onTap: () {print("name tap"); },),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildUnknownBoard() {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.yellow,
            )
        ),
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              _buildTitleSection(100.0, "미확인"),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile(title: Text("강예찬"), trailing: Text("123"), onTap: () {print("name tap"); },),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            color: Colors.yellow,
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
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

}
