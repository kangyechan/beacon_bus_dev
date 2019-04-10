import 'package:flutter/material.dart';

class TeacherBoardScreen extends StatefulWidget {
  final int carNum;

  const TeacherBoardScreen({Key key, this.carNum}): super(key: key);

  @override
  _TeacherBoardScreenState createState() => _TeacherBoardScreenState(carNum: carNum);
}

class _TeacherBoardScreenState extends State<TeacherBoardScreen> {
  final int carNum;

  _TeacherBoardScreenState({this.carNum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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

  Widget _buildStateSection() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
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
          _buildTitleSection(150.0, "현재 탑승목록"),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.0),
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
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.yellow,
        child: Text("운행 종료"),
        onPressed: () {

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
        padding: const EdgeInsets.all(5.0),
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

}
