import 'package:beacon_bus/blocs/teacher_provider.dart';
import 'package:beacon_bus/screens/board_list_screen.dart';
import 'package:flutter/material.dart';

class TeacherBusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = TeacherProvider.of(context);

    return Scaffold(
      body: Center(

        child: Column(
          children: <Widget>[
            Text("1호차"),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final carNum = 1;

    return FlatButton(
      child: Text("운행시작"),
      color: Colors.yellow,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BoardListScreen(carNum: carNum,)
          ),
        );
      },
    );
  }
}
