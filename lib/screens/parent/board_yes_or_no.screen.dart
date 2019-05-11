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
          Divider(),
          SizedBox(height: 50.0,),
          Text('상태 메뉴얼', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('탑승할 경우       '),
              Switch(
                onChanged: (value) {
                },
                value: true,
                activeColor: Colors.blue,
              ),
              Text('탑승'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('탑승하지 않을 경우  '),
              Switch(
                onChanged: (value) {
                },
                value: false,
                activeColor: Colors.blue,
              ),
              Text('미탑승'),
            ],
          ),

          SizedBox(height: 80.0,),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return Text('탑승 유무', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),);
  }

}


