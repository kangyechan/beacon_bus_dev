import 'package:cloud_firestore/cloud_firestore.dart';

class Children {
  final String id;
  final String phoneNumber;
  final String protector;

  final String name;
  final String classRoom;
  final String busNum;
  String boardState;
  final String activityState;
  final String changeStateTime;

  final String beaconUid;
  final String beaconMajor;
  final String beaconMinor;
  int connectTime = 0;
  int noConnectTime = 0;
  bool link = false;

  final DocumentReference reference;

  Children.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['phoneNumber'] != null),
        assert(map['protector'] != null),

        assert(map['name'] != null),
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
        classRoom = map['classRoom'],
        busNum = map['busNum'],
        boardState = map['boardState'],
        activityState = map['activityState'],
        changeStateTime = map['changeStateTime'],

        beaconUid = map['beaconUid'],
        beaconMajor = map['beaconMajor'],
        beaconMinor = map['beaconMinor'];

  Children.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Children<$name:$phoneNumber";
}