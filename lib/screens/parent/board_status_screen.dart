import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:beacon_bus/screens/parent/widgets/board_state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BoardStatusScreen extends StatelessWidget {
  final Color getOnColor = Colors.blue;
  final Color getOffColor = Colors.grey.shade300;
  final Color notBoardColor = Colors.yellow;

  static const platform = const MethodChannel('sendSms');

  Future<Null> sendSms() async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+8201049220759","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  click() {
    print('hi');
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);

    return Scaffold(
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, ParentBloc bloc) {
    return Container(
      width: 1000.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDateText(bloc),
          SizedBox(
            height: 50.0,
          ),
          _buildStateIndicator(bloc),
          RaisedButton(
            child: Text('hi'),
            onPressed: () {
              sendSms();
            },
          )
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
                    color: Colors.grey.shade600),
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
        });
  }

  Widget _buildStateIndicator(ParentBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.childId,
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
                        bloc.calculateFormattedDateYMD(DateTime.now());
                    Children child = Children.fromMap(snapshot.data.data);
                    List<String> notBoardingDateList =
                        List<String>.from(child.notBoardingDateList);
                    bool containBoardingDate =
                        notBoardingDateList.contains(date);
                    // 시간에서 연월시분을 시분만 남기기
                    String changeStateTime = bloc
                        .changeForamtToGetOnlyDateAndDay(child.changeStateTime);
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
            } else {
              return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection("Kindergarden")
                    .document('hamang')
                    .collection('Children')
                    .document(childId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  List<String> recordList =
                      List<String>.from(snapshot.data.data['record']);
                  String date = '';
                  String getOnTime = '승차 정보 없음';
                  String getOffTime = '';

                  for (final recordItem in recordList) {
                    if (recordItem.contains(
                        bloc.calculateFormattedDateYMD(selectedDate))) {
                      print(recordItem);
                      getOnTime = "승차: ${recordItem.split(',')[1]}";
                      getOffTime = "하차: ${recordItem.split(',')[2]}";
                    }
                    break;
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        height: 300.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150.0),
                          color: Colors.blue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Image.asset(
                                  'images/background.JPG',
                                  width: 100.0,
                                ),
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
                        height: 30.0,
                      ),
                      FlatButton(
                        child: Text(
                          '처음으로',
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          bloc.changeSelectedDate(DateTime.now());
                        },
                      )
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
