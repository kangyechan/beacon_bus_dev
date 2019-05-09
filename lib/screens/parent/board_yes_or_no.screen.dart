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
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      width: 1000.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30.0,),
          _buildTitleText(),
          SizedBox(height: 20.0,),
         BoardScheduleList(),
          Divider(),
          SizedBox(height: 10.0,),
          Text('상태 메뉴얼', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
          SizedBox(height: 10.0,),
          _buildSampleSwitchButton('탑승'),
          _buildSampleSwitchButton('미탑승'),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }

  Widget _buildSampleSwitchButton(String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        type == "탑승" ? Text("탑승할 경우          ") : Text("탑승하지 않을 경우"),
        Switch(
          onChanged: (value) {
          },
          value: type == "탑승" ? true : false,
          activeColor: Colors.blue,
        ),
        Text(type),
      ],
    );
  }

  Widget _buildTitleText() {
    return Text('탑승 유무', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),);
  }

}


