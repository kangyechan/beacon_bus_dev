import 'package:flutter/material.dart';

class TeacherBusScreen extends StatefulWidget {
  final int carNum;
  TeacherBusScreen({Key key, this.carNum}): super(key: key);
  @override
  _TeacherBusScreenState createState() => _TeacherBusScreenState(carNum: carNum);
}

class _TeacherBusScreenState extends State<TeacherBusScreen> {
  final int carNum;
  _TeacherBusScreenState({this.carNum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            _buildStateSection(),
            _buildBoardSection(),
            _buildEndBoard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text("소담 어린이집 " + carNum.toString() + " 호차"),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _buildStateSection() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          _buildState(Icon(Icons.check_circle), Colors.green, "탑승중"),
          _buildState(Icon(Icons.cancel), Colors.red, "미탑승"),
          _buildState(Icon(Icons.error), Colors.orange, "개인이동"),
        ],
      )
    );
  }

  Widget _buildState(Icon stateIcon, Color stateColor, String name){
    return Flexible(
      flex: 1,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                color: stateColor,
              ),
              child: stateIcon,
            ),
          ),
          Expanded(
            child: Text(name),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardSection() {
    return Flexible(
      flex: 3,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _buildTitleSection(200.0, "현재 탑승 상태"),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("강예찬"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.cancel,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("최선웅"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("박경찬"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("손경진"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("박성윤"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.orange,
                      ),
                      child: Icon(
                        Icons.error,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("이정은"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                  ListTile(
                    title: Text("추유진"),
                    trailing: IconTheme(
                      data: IconThemeData(
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check_circle,
                      ),
                    ),
                    onTap: () {
                      print("name tap");
                    },
                  ),
                  _divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndBoard() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.yellow,
        child: Text("운행 종료"),
        onPressed: () {
          _showDialog();
        },
      ),
    );
  }

  Widget _buildTitleSection(double width, String title) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.yellow,
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.0,
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("운행 종료"),
          content: Text("모든 학생의 상태를 확인하셨나요?\n정말 종료하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "한번 더 확인하기",

              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "종료하기",

              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
