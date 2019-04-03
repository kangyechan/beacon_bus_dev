import 'package:beacon_bus/blocs/teacher/teacher_provider.dart';
import 'package:beacon_bus/screens/teacher/board_list_screen.dart';
import 'package:flutter/material.dart';

class TeacherBusScreen extends StatefulWidget {
  @override
  _TeacherBusScreenState createState() => _TeacherBusScreenState();
}

class _TeacherBusScreenState extends State<TeacherBusScreen> {

  final List<String> _busNumber = ["1호차", "2호차", "3호차", "4호차", "5호차", "6호차"];
  String dropdownValue;
  int carNum;

  @override
  Widget build(BuildContext context) {
    final bloc = TeacherProvider.of(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100.0),
                _buildDropdownButton(),
                SizedBox(height: 30.0),
                _buildButton(context, carNum),
              ],
            ),
          ),
          Expanded(
            child: _buildBackground(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, int carNum) {
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

  Widget _buildDropdownButton() {
    return  DropdownButton(
      value: dropdownValue,
      onChanged: (String value) {
        setState(() {
          dropdownValue = value;
          carNum = _busNumber.indexWhere((num) => num.startsWith(value)) + 1;
        });
      },
      items: _busNumber.map((value) => DropdownMenuItem(
        value: value,
        child: Text(value),
      )).toList(),
      hint: Text("운행 차량"),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'images/background.JPG',
    );
  }

}
