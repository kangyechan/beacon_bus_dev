import 'package:beacon_bus/constants.dart';
import 'package:flutter/material.dart';


class TeacherMyPageScreen extends StatefulWidget {

  @override
  _TeacherMyPageScreenState createState() => _TeacherMyPageScreenState();
}

class _TeacherMyPageScreenState extends State<TeacherMyPageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: Container(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                _buildImageSection(),
                _buildNameSection(),
                _buildClassSection(),
                _buildPhoneSection(),
              ],
            )
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
          dispose();
        },
      ),
      title: Text(
        '마이페이지',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFFC9EBF7),
    );
  }

  Widget _buildImageSection() {
    return Container();
  }

  Widget _buildNameSection() {
    return Container();
  }

  Widget _buildClassSection() {
    return Container();
  }

  Widget _buildPhoneSection() {
    return Container();
  }
}
