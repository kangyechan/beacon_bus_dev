import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'tab_ranging.dart';

class BeaconScreen extends StatefulWidget {
  @override
  _BeaconScreenState createState() => _BeaconScreenState();
}

class _BeaconScreenState extends State<BeaconScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Beacon test'),
        ),
        body: Column(
          children: <Widget>[
            RangingTab(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Kindergarden')
          .document('hamang')
          .collection('Children')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final userdata = UserData.fromSnapshot(data);
    return Padding(
      key: ValueKey(userdata.phoneNumber),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          alignment: Alignment.center,
          height: 68,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
              title: Text(userdata.name),
              trailing: userdata.boardState == 'board'
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.check_circle, color: Colors.red))),
    );
  }
}

class UserData {
  final String beaconMajor;
  final String beaconMinor;
  final String beaconUid;
  String boardState;
  final String busNum;
  final String classRoom;
  final String id;
  final String name;
  final String phoneNumber;
  int connectTime = 0;
  int noConnectTime = 0;
  bool link = false;
  final DocumentReference reference;

  UserData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['beaconMajor'] != null),
        assert(map['beaconMinor'] != null),
        assert(map['beaconUid'] != null),
        assert(map['boardState'] != null),
        assert(map['busNum'] != null),
        assert(map['classRoom'] != null),
        assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['phoneNumber'] != null),
        beaconMajor = map['beaconMajor'],
        beaconMinor = map['beaconMinor'],
        beaconUid = map['beaconUid'],
        boardState = map['boardState'],
        busNum = map['busNum'],
        classRoom = map['classRoom'],
        id = map['id'],
        name = map['name'],
        phoneNumber = map['phoneNumber'];

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "UserData<$beaconMajor:$beaconMinor:$beaconUid:$boardState:$busNum:$name:$phoneNumber";
}
