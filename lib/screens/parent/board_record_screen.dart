import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:beacon_bus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ParentBloc bloc = ParentProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('승하차기록'),
      ),
      body: _buildBody(bloc),
    );
  }
}

Widget _buildBody(ParentBloc bloc) {
  return StreamBuilder<String>(
    stream: bloc.childId,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      String childId = snapshot.data;

      return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('Kindergarden')
            .document('hamang')
            .collection('Children')
            .document(childId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          List<String> recordList = List<String>.from(snapshot.data.data['record']);

          return ListView(
            children:
            recordList.map((String record) => _buildListTile(record)).toList(),
          );
        },
      );
    },
  );
}

Widget _buildListTile(String record) {
  return Column(
    children: <Widget>[
      ListTile(
        title: Text(record.split(',')[0]),
        subtitle: Container(
          margin: EdgeInsets.only(top: 5.0),
          child:
              Row(
                children: <Widget>[
                  Text("승차 : ${record.split(',')[1]} "),
                  Text("하차 : ${record.split(',')[2]}")
                ],
              ),
        ),

      ),
      Divider(),
    ],
  );
}
