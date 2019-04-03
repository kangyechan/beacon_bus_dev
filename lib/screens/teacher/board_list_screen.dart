import 'package:flutter/material.dart';

class BoardListScreen extends StatelessWidget {
  final int carNum;

  BoardListScreen({this.carNum});

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
            Expanded(
              child: Column( // 현재탑승목록 부분
                children: <Widget>[
                  Text("현재 탑승목록"),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text("이름")),
                      Expanded(child: Text("승하차 장소")),
                    ],
                  ),

                ],
              ),
            ),
            Container(
              height: 200.0,
              child: Row( // 나머지 두 부분
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text("미탑승"),
                        ListTile(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text("미확인"),
                        ListTile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
