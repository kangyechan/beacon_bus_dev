import 'package:cloud_firestore/cloud_firestore.dart';

class Children {
  final String id;
  final String phoneNumber;
  final String protector;

  final String name;
  final String profileImageUrl;
  final String classRoom;
  final String busNum;
  String boardState;
  String activityState;
  final String changeStateTime;

  final String beaconUid;
  final String beaconMajor;
  final String beaconMinor;
  int connectTime = 0;
  int noConnectTime = 0;
  bool link = false;
  List notBoardingDateList;
  final String currentBusLogDocumentId;

  final DocumentReference reference;

  Children.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['phoneNumber'] != null),
        assert(map['protector'] != null),

        assert(map['name'] != null),
        assert(map['profileImageUrl'] != null),
        assert(map['classRoom'] != null),
        assert(map['busNum'] != null),
        assert(map['boardState'] != null),
        assert(map['activityState'] != null),
        assert(map['changeStateTime'] != null),

        assert(map['beaconUid'] != null),
        assert(map['beaconMajor'] != null),
        assert(map['beaconMinor'] != null),

        id = map['id'],
        phoneNumber = map['phoneNumber'],
        protector = map['protector'],

        name = map['name'],
        profileImageUrl = map['profileImageUrl'],
        classRoom = map['classRoom'],
        busNum = map['busNum'],
        boardState = map['boardState'],
        activityState = map['activityState'],
        changeStateTime = map['changeStateTime'],

        beaconUid = map['beaconUid'],
        beaconMajor = map['beaconMajor'],
        beaconMinor = map['beaconMinor'],
        notBoardingDateList = map['notBoardingDateList'] ?? [],
        currentBusLogDocumentId = map['currentBusLogDocumentId'] ?? "";

  Children.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Children<$name:$phoneNumber";
}