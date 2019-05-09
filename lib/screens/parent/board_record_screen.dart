import 'package:beacon_bus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParentRecordScreen extends StatefulWidget {
  @override
  _ParentRecordScreenState createState() => _ParentRecordScreenState();
}

class _ParentRecordScreenState extends State<ParentRecordScreen> {
  TextEditingController keyword = TextEditingController();
  String dropdownValue;
  String searchText;
  String busNum;

  Widget _buildListTitle() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          _buildListTitleName('날짜'),
          _buildListTitleName('승차시간'),
          _buildListTitleName('하차시간'),
        ],
      ),
    );
  }
  Widget _buildListTitleName(String name) {
    return Expanded(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildBody(){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Kindergarden')
          .document('hamang')
          .collection('Log')
          .where('name', isEqualTo: searchText)
          .where('busNum', isEqualTo: busNum)
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        print(searchText);
        print(busNum);
        return _logListContents(context, snapshot.data.documents);
      },
    );
  }

  Widget _logListContents(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top:5.0, left: 10.0, right: 10.0),
      children: snapshot.map((data) => _logListItem(context, data)).toList(),
    );
  }

  Widget _logListItem(BuildContext context, DocumentSnapshot data) {
    Map map = Map.from(data.data['boardRecord']);
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          _buildLogListItem(map['date']),
          _buildLogListItem(map['board']),
          _buildLogListItem(map['unknown']),
        ],
      ),
    );
  }
  Widget _buildLogListItem(String name) {
    return Expanded(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        "승하차 기록",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              _buildListTitle(),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}





//Widget _buildListTile(String record) {
//  return Column(
//    children: <Widget>[
//      ListTile(
//        title: Text(record.split(',')[0]),
//        subtitle: Container(
//          margin: EdgeInsets.only(top: 5.0),
//          child:
//              Row(
//                children: <Widget>[
//                  Text("승차 : ${record.split(',')[1]} "),
//                  Text("하차 : ${record.split(',')[2]}")
//                ],
//              ),
//        ),
//
//      ),
//      Divider(),
//    ],
//  );
//}
