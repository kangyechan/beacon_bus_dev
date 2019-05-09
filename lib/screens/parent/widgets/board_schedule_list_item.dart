import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardScheduleListItem extends StatelessWidget {
  final String date;
  final bool containBoardingDate;

  BoardScheduleListItem({this.date, this.containBoardingDate});

  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);
    if (containBoardingDate) {
      return ListTile(
        leading: Text(date),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Switch(
              onChanged: (value) {
                boardAlertDialog(context, date, bloc, false);
              },
              value: false,
              activeColor: Colors.blue,
            ),
            Text('미탑승'),
          ],
        ),
      );
    } else {
      return ListTile(
        leading: Text(date),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Switch(
              onChanged: (value) {
                boardAlertDialog(context, date, bloc, true);
              },
              value: true,
              activeColor: Colors.blue,
            ),
            Text('탑승'),
          ],
        ),
      );
    }
  }

  void boardAlertDialog(
      BuildContext context, String selectedDate, ParentBloc bloc, bool status) {
    bloc.changeBoardingStatus(selectedDate);
//    String content = "";
//    if (status)
//      content = "$selectedDate에\n 탑승하지 않으시겠습니까?";
//    else
//      content = "$selectedDate에\n 탑승하시겠습니까?";
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return CupertinoAlertDialog(
//          title: Text('알림'),
//          content: Text(content),
//          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text('예'),
//              onPressed: () {
//                bloc.changeBoardingStatus(selectedDate);
//                Navigator.pop(context);
//              },
//            ),
//            CupertinoDialogAction(
//              child: Text('아니오'),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            )
//          ],
//        );
//      },
//    );
  }
}
