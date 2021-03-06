import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = LoginProvider.of(context);
    return Scaffold(
      appBar: _buildAppbar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              _buildListTitle(),
              Expanded(
                child: _buildBody(loginBloc),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

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

  Widget _buildBody(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.childId,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        String childId = snapshot.data;

        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Kindergarden')
              .document('hamang')
              .collection('BusLog')
              .where('id', isEqualTo: childId)
              .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return LinearProgressIndicator();
            print(searchText);
            print(busNum);
            return _logListContents(context, snapshot.data.documents);
          },
        );
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
          _buildLogListItem(map['date'].toString().substring(6).split('').reversed.join().substring(3).split('').reversed.join()),
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
}