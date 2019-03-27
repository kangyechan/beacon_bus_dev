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
      body: Column(
        children: <Widget>[
          Column(
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
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text("미탑승"),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("이름")),
                        Expanded(child: Text("승하차 장소")),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text("미확인"),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("이름")),
                        Expanded(child: Text("승하차 장소")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
