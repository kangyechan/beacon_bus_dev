import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'board_schedule_list_item.dart';

class BoardScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);
    List<String> oneWeekList = bloc.getOneWeekDate();

    return Flexible(
      child: FutureBuilder(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final FirebaseUser user = snapshot.data;

          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Kindergarden')
                .document('hamang')
                .collection('Users')
                .document(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return ListView(
                children: oneWeekList.map(
                  (String date) {
                    // 토요일이나 일요일인 경우에 리스트에서 제외
                    if (date.split('').reversed.join('')[2] != "토" &&
                        date.split('').reversed.join('')[2] != "일") {
                      List<String> notBoardingDateList = List<String>.from(
                          snapshot.data.data['notBoardingDateList']);
                      bool containBoardingDate =
                          notBoardingDateList.contains(date);
                      return BoardScheduleListItem(
                          date: date, containBoardingDate: containBoardingDate);
                    } else {
                      return Opacity(
                        opacity: 0.0,
                      );
                    }
                  },
                ).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
