import 'dart:async';

import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:beacon_bus/screens/parent/widgets/board_state_profile_image_widget.dart';
import 'package:beacon_bus/screens/parent/widgets/board_state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BoardStatusScreen extends StatelessWidget {
  final Color getOnColor = Colors.blue;
  final Color getOffColor = Colors.grey.shade300;
  final Color notBoardColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    final parentBloc = ParentProvider.of(context);
    final loginBloc = LoginProvider.of(context);
    const platform = const MethodChannel('sendSms');

    Future<Null> sendSms() async {
      print("SendSMS");
      try {
        final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+821049220759","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
        print(result);
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }

    sendSms();

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context, parentBloc, loginBloc),
    );
  }

  Widget _buildBody(
      BuildContext context, ParentBloc parentBloc, LoginBloc loginBloc) {
    return Container(
      width: 1000.0,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          _buildDateText(parentBloc),
          SizedBox(
            height: 30.0,
          ),
          _buildStateIndicator(parentBloc, loginBloc),
//          _buildProtectorText(context, loginBloc),
        ],
      ),
    );
  }

  Widget _buildDateText(ParentBloc bloc) {
    return StreamBuilder<DateTime>(
      stream: bloc.selectedDate,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Text(
            "1월 1일 월요일",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
                color: Colors.grey.shade600),
          );
        DateTime selectedDate = snapshot.data;
        DateTime currentTime = DateTime.now();
        String formattedSelectedDate =
            bloc.calculateFormattedDateMDE(selectedDate);
        String formattedCurrentDate =
            bloc.calculateFormattedDateMDE(currentTime);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.grey.shade600,
                size: 35.0,
              ),
              onPressed: () {
                bloc.changeSelectedDate(selectedDate.add(Duration(days: -1)));
              },
            ),
            Text(
              formattedSelectedDate,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.blueGrey.shade600),
            ),
            formattedSelectedDate == formattedCurrentDate
                ? IconButton(
                    icon: Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 35.0),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(Icons.keyboard_arrow_right,
                        color: Colors.grey.shade600, size: 35.0),
                    onPressed: () {
                      bloc.changeSelectedDate(
                          selectedDate.add(Duration(days: 1)));
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _buildStateIndicator(ParentBloc bloc, LoginBloc loginBloc) {
    return StreamBuilder<String>(
      stream: loginBloc.childId,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        String childId = snapshot.data;
        return StreamBuilder(
          stream: bloc.selectedDate,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            DateTime selectedDate = snapshot.data;
            DateTime currentTime = DateTime.now();
            String formattedSelectedDate =
                bloc.calculateFormattedDateMDE(selectedDate);
            String formattedCurrentDate =
                bloc.calculateFormattedDateMDE(currentTime);
            // 오늘 날짜를 보여줄 경우
            if (formattedSelectedDate == formattedCurrentDate) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection("Kindergarden")
                      .document('hamang')
                      .collection('Children')
                      .document(childId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    String date =
                        bloc.calculateFormattedDateYMDE(DateTime.now());
                    Children child = Children.fromMap(snapshot.data.data);
                    List<String> notBoardingDateList =
                        List<String>.from(child.notBoardingDateList);
                    bool containBoardingDate =
                        notBoardingDateList.contains(date);
                    // 시간에서 연월시분을 시분만 남기기
                    String changeStateTime = bloc
                        .changeFormatToGetOnlyDateAndDay(child.changeStateTime);
                    Widget childBoardingStateWidget;
                    if (child.boardState == "board") {
                      childBoardingStateWidget = BoardStateWidget(
                        state: "board",
                        color: getOnColor,
                        busNum: child.busNum,
                        changeStateItem: changeStateTime,
                      );
                    } else if (containBoardingDate) {
                      childBoardingStateWidget = BoardStateWidget(
                        state: "notboard",
                        color: notBoardColor,
                        busNum: "notboard",
                        changeStateItem: "notboard",
                      );
                    } else {
                      childBoardingStateWidget = BoardStateWidget(
                        state: "unknown",
                        color: getOffColor,
                        busNum: child.busNum,
                        changeStateItem: changeStateTime,
                      );
                    }
                    return childBoardingStateWidget;
                  });
              // 이전 날짜를 보여줄 경우
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("Kindergarden")
                    .document('hamang')
                    .collection('BusLog')
                    .where('id', isEqualTo: childId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  String getOnTime = '승차 정보 없음';
                  String getOffTime = '';
                  for (final document in snapshot.data.documents) {
                    Map<dynamic, dynamic> recordMap = document.data['boardRecord'];
                    if (recordMap['date'] == bloc.calculateFormattedDateYMDE(selectedDate)) {
                      getOnTime = "승차 : ${recordMap['board']}";
                      getOffTime = "하차 : ${recordMap['unknown']}";
                      break;
                    }
                  }
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 15.0,),
                      Container(
                        width: 300.0,
                        height: 300.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: BoardStateProfileImageWidget(),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              getOnTime,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              getOffTime,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FlatButton(
                        child: Text(
                          '처음으로',
                          style: TextStyle(color: Colors.green.shade200, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          bloc.changeSelectedDate(DateTime.now());
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
