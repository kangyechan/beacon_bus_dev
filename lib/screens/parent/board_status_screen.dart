import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/screens/parent/widgets/board_state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:intl/intl.dart';

class BoardStatusScreen extends StatelessWidget {
  String childId;
  final Color getOnColor = Colors.blue;
  final Color getOffColor = Colors.grey.shade300;
  final Color notBoardColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);
    childId = bloc.prefs.getString(CHILD_ID);
    
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
        ],
      ),
    );
  }

  Widget _buildDateText(ParentBloc bloc) {
    String currentDate = bloc.getCurrentDate();
    bloc.getOneWeekDate();
    return Text(
      currentDate,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35.0,
          color: Colors.grey.shade600),
    );
  }

  Widget _buildStateIndicator(ParentBloc bloc) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("Kindergarden").document('hamang').collection('Children').document(childId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        String boardState = snapshot.data.data['boardState'];
        String name = snapshot.data.data['name'];
        String busNum = snapshot.data.data['busNum'];
        String changeStateTime = snapshot.data.data['changeStateTime'];

        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat.y().add_M().add_d().add_EEEE();
        String unFormattedTime = formatter.format(now).toString();
        String date = bloc.getFormattedDate(unFormattedTime);
        List<String> notBoardingDateList = List<String>.from(
            snapshot.data.data['notBoardingDateList']);
        bool containBoardingDate =
        notBoardingDateList.contains(date);
        print("hi $containBoardingDate");
        // 시간에서 연월시분을 시분만 남기기
        changeStateTime = changeStateTime.split('').reversed.join('').substring(0, 5).split('').reversed.join('');
        Widget childBoardingStateWidget;
        if (boardState == "board") {
          childBoardingStateWidget = BoardStateWidget(color: getOnColor, busNum: busNum, changeStateItem: changeStateTime,);
        } else if (containBoardingDate) {
          childBoardingStateWidget = BoardStateWidget(color: notBoardColor, busNum: "notboard", changeStateItem: "notboard",);
        } else {
          childBoardingStateWidget = BoardStateWidget(color: getOffColor, busNum: busNum, changeStateItem: changeStateTime,);
        }

        return childBoardingStateWidget;
      }
    );

//    return Container(
//      width: 300.0,
//      height: 300.0,
//      alignment: Alignment.center,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(150.0),
//        color: Colors.grey,
//      ),
//      child: Column(
//        children: <Widget>[
//          Expanded(
//            child: Padding(
//              padding: const EdgeInsets.only(top: 50.0),
//              child: Image.asset(
//                'images/background.JPG',
//                width: 100.0,
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(bottom: 5.0),
//            child: Text('00시 00분', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(bottom: 30.0),
//            child: Text('하차 완료', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
//          ),
//        ],
//      ),
//    );
  }
}
