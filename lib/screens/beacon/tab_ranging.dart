import 'dart:async';

import 'package:beacon_bus/blocs/parent/parent_date_helpers.dart';
import 'package:beacon_bus/models/children.dart';
import 'package:beacon_bus/screens/teacher/widgets/alarm.dart';
import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tab_base.dart';

class RangingTab extends ListTab with ParentDateHelpers {
  String _busNum;
  String _className;
  int _distance;
  int check = 0;
  int stackTime = 8;
  int noStackTime = 8;
  List<Children> userResults = [];

  Alarm alarm = new Alarm();

  RangingTab.origin() {
    this._busNum = '';
    this._className = '';
    this._distance = 5;
  }

  RangingTab(String busNum, String className, int distance) {
    this._distance = distance;
    if (busNum == '') {
      this._busNum = null;
    } else {
      this._busNum = busNum;
    }
    if (className == '') {
      this._className = null;
    } else {
      this._className = className;
    }
  }

  @override
  Stream<ListTabResult> stream(BeaconRegion region) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Children')
        .where('busNum', isEqualTo: _busNum)
        .where('classRoom', isEqualTo: _className)
        .snapshots()
        .forEach((data) {
      userResults.clear();
      data.documents.forEach((data) {
        var userdata = Children.fromSnapshot(data);
        userResults.add(userdata);
      });
    });
    return Beacons.ranging(
      region: region,
      inBackground: false,
    ).map((result) {
      if (result.isSuccessful) {
        for (var data in userResults) {
          for (var beacon in result.beacons) {
            if (beacon.ids[1].toString() == data.beaconMajor &&
                beacon.ids[2].toString() == data.beaconMinor &&
                beacon.ids[0] == "fda50693-a4e2-4fb1-afcf-c6eb07647825" &&
                beacon.distance < _distance) {
              data.link = true;
              break;
            } else {
              data.link = false;
            }
          }
        }
        if (_className == null && _busNum != null) {
          for (var data in userResults) {
            print(userResults);
            if (data.link == true) {
              data.connectTime++;
              data.noConnectTime = 0;
              if (data.connectTime == stackTime && data.boardState != 'board') {
                Firestore.instance
                    .collection('Kindergarden')
                    .document('hamang')
                    .collection('Children')
                    .document(data.id)
                    .updateData({'boardState': 'board'}).then((done) {
                  Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('BusLog')
                      .document()
                      .setData({
                    'id': data.id,
                    'boardRecord': {
                      'date': calculateFormattedDateYMDE(DateTime.now()),
                      'board':
                      calculateFormattedDateHourAndMinute(DateTime.now()),
                      'unknown': ""
                    },
                    'name': data.name,
                    'busNum': _busNum,
                  });
                });
                alarm.showNotification(
                    int.parse(data.beaconMajor), data.name + '이 승차했습니다.');
              }
            } else {
              data.noConnectTime++;
              data.connectTime = 0;
              if (data.boardState == 'board') {
                if (data.noConnectTime == noStackTime &&
                    data.boardState != 'board') {
                  data.boardState = 'unknown';
                  Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('Children')
                      .document(data.id)
                      .updateData({'boardState': 'unknown'}).then((done) {
                    Firestore.instance
                        .collection('Kindergarden')
                        .document('hamang')
                        .collection('BusLog')
                        .where('id', isEqualTo: data.id)
                        .snapshots()
                        .listen((data) {
                      Map newBoardRecordMap = data.documents[0]['boardRecord'];
                      newBoardRecordMap['unknown'] =
                          calculateFormattedDateHourAndMinute(DateTime.now());
                      Firestore.instance
                          .collection('Kindergarden')
                          .document('hamang')
                          .collection('BusLog')
                          .document(data.documents[0].documentID)
                          .updateData({'boardRecord': newBoardRecordMap});
                    });
                  });
                  alarm.showNotification(
                      int.parse(data.beaconMajor), data.name + '이 하차했습니다.');
                }
              }
            }
          }
        } else if (_className != null && _busNum == null) {
          for (var data in userResults) {
            print(userResults);
            if (data.link == true) {
              data.connectTime++;
              data.noConnectTime = 0;
              if (data.connectTime == stackTime && data.activityState != 'in') {
                Firestore.instance
                    .collection('Kindergarden')
                    .document('hamang')
                    .collection('Children')
                    .document(data.id)
                    .updateData({'activityState': 'in'});
                alarm.showNotification(
                    int.parse(data.beaconMajor), data.name + '이 범위로 들어왔습니다.');
              }
            } else {
              data.noConnectTime++;
              data.connectTime = 0;
              if (data.activityState == 'in') {
                if (data.noConnectTime == noStackTime) {
                  data.activityState = 'out';
                  Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('Children')
                      .document(data.id)
                      .updateData({'activityState': 'out'});
                  alarm.showNotification(
                      int.parse(data.beaconMajor), data.name + '이 범위를 이탈했습니다.');
                }
              }
            }
          }
        }
      }
      return ListTabResult(
        isSuccessful: result.isSuccessful,
      );
    });
  }
}