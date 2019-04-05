import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardYesOrNoScreen extends StatelessWidget {
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
        children: <Widget>[
          SizedBox(height: 50.0,),
          _buildTitleText(),
          SizedBox(height: 50.0,),
         _buildBoardScheduleList(context, bloc),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return Text('탑승 유무', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),);
  }

  Widget _buildBoardScheduleList(BuildContext context, ParentBloc bloc) {
    List<String> oneWeekList = bloc.getOneWeekDate();

    // Todo: ListView 만들기 전에 파이어베이스에서 미탑승 리스트 받아와서 비교 후 랜더링
    return Flexible(
      child: ListView(
        children: oneWeekList.map((String date) {
          if (date.split('').reversed.join('')[2] != "토" && date.split('').reversed.join('')[2] != "일") {
            return ListTile(
              leading: Text(date),
              trailing: Text("탑승여부: O"),
              onTap: () {
                // Todo: 탑승 안한다고 할 때 로직

                // 파이어베이스 자신의 미탑승 array에 추가하기 및 제거하기

                // 교사 앱에서 받아올 때 arraycontains로 처리
                boardAlertDialog(context, date);
              },
            );
          } else {
            return Opacity(opacity: 0.0,);
          }
        }).toList(),
      ),
    );
  }

  void boardAlertDialog(BuildContext context, String currentDate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('$currentDate에\n 탑승하지 않으시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('아니오'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}


