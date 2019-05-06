//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0
//
//import 'dart:async';
//
//import 'package:beacons/beacons.dart';
//
//import 'tab_base.dart';
//
//class RangingTab extends ListTab {
//  RangingTab() : super(title: 'Ranging');
//
//  @override
//  Stream<ListTabResult> stream(BeaconRegion region) {
//    return Beacons.ranging(
//      region: region,
//      inBackground: false,
//    ).map((result) {
//      String text;
//      if (result.isSuccessful) {
//        text = result.beacons.isNotEmpty
//            ? 'UUID: ${result.beacons.first.ids[1]}' //0: uuid, 1: major, 2:minor
//            : 'No beacon in range';
//      } else {
//        text = result.error.toString();
//      }
//
//      return new ListTabResult(text: text, isSuccessful: result.isSuccessful);
//    });
//  }
//}

import 'dart:async';

import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'beacon_screen.dart';
import 'tab_base.dart';

class RangingTab extends ListTab {
  int check = 0;
  bool turnon = false;
  List<UserData> userResults = [];

  @override
  Stream<ListTabResult> stream(BeaconRegion region) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Children')
        .snapshots()
        .forEach((data) {
      data.documents.forEach((data) {
        var userdata = UserData.fromSnapshot(data);
        userResults.add(userdata);
      });
    });
    return Beacons.ranging(
      region: region,
      inBackground: false,
    ).map((result) {
      String text;

      if (result.isSuccessful) {
        //1초마다 돌아오는 곳?
        check++;
        text = result.beacons.isNotEmpty
            ? 'UUID: ${result.beacons.first.ids[1]}'
            : 'No beacon in range';
        for (var data in userResults) {
          for (var beacon in result.beacons) {
            print(beacon.distance);
            if (beacon.ids[1].toString() == data.beaconMajor &&
                beacon.ids[2].toString() == data.beaconMinor &&
                beacon.ids[0] == "fda50693-a4e2-4fb1-afcf-c6eb07647825"&&beacon.distance<5) {
              data.link = true;
              break;
            } else {
              data.link = false;
            }
          }
        }
        for (var data in userResults) {
          if (data.link == true) {
            data.connectTime++;
            data.noConnectTime = 0;
            if (data.connectTime == 10) {
              Firestore.instance
                  .collection('Kindergarden')
                  .document('hamang')
                  .collection('Children')
                  .document(data.id)
                  .updateData({'boardState': 'board'});
            }
          } else {
            data.noConnectTime++;
            data.connectTime = 0;
            if (data.boardState == 'board') {
              if (data.noConnectTime == 10) {
                data.boardState = 'unknown';
                Firestore.instance
                    .collection('Kindergarden')
                    .document('hamang')
                    .collection('Children')
                    .document(data.id)
                    .updateData({'boardState': 'unknown'});
              }
            }
          }
        }
      } else {
        text = result.error.toString();
      }
      return ListTabResult(
        text: text,
        isSuccessful: result.isSuccessful,
        check: check,
      );
    });
  }
}
