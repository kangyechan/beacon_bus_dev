import 'package:beacon_bus/screens/parent/widgets/board_schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';


class BoardYesOrNoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);
    return Scaffold(
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, ParentBloc bloc) {
    return Container(
      width: 1000.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0,),
          _buildTitleText(),
          SizedBox(height: 50.0,),
         BoardScheduleList(),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return Text('탑승 유무', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),);
  }

}


