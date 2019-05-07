import 'dart:async';

import 'package:beacon_bus/models/children.dart';
import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tab_base.dart';

class RangingTab extends ListTab {
  int check = 0;
  bool turnon = false;
  List<Children> userResults = [];

  @override
  Stream<ListTabResult> stream(BeaconRegion region) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Children')
        .snapshots()
        .forEach((data) {
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
                beacon.distance < 5) {
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
      }
      return ListTabResult(
        isSuccessful: result.isSuccessful,
      );
    });
  }
}