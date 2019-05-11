import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/constants.dart';
import 'package:beacon_bus/screens/beacon/tab_ranging.dart';
import 'package:beacon_bus/screens/teacher/teacher_activity_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_bus_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {

  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {

  String dropdownValue;
  int carNum;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      drawer: Drawer(
        child: _buildDrawer(bloc),
      ),
      body: SafeArea(
        child: Container(
          width: queryData.size.width,
          child: FutureBuilder<FirebaseUser>(
            future: bloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              FirebaseUser user = snapshot.data;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text(" ");
                        String name = snapshot.data.data['name'];
                        return Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            SizedBox(height: 10.0,),
                            _teacherName(name),
                            _buildReadMe(name),
                            SizedBox(height: 10.0,),
                            _buildDropdownButton(),
                            _buildButton(context, name, carNum),
                          ],
                        );
                      }
                    ),
                  ),
                  Expanded(
                    child: _buildBackground(queryData),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text(
        SCHOOL_NAME,
        style: TextStyle(
          fontWeight: FontWeight. bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFFC9EBF7),
    );
  }
  Widget _buildDrawer(LoginBloc bloc) {
    return Column(
      children: <Widget>[
        _buildUserAccounts(bloc),
        _buildDrawerList(bloc),
        _divider(),
        _logoutDrawer(bloc),
      ],
    );
  }
  Widget _buildUserAccounts(LoginBloc bloc) {
    return Container(
      height: 200.0,
      child: FutureBuilder<FirebaseUser>(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          FirebaseUser user = snapshot.data;
          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFC9EBF7),
            ),
            margin: EdgeInsets.all(0.0),
            accountName: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text(" ");
                  String name = snapshot.data.data['name'];
                  return Text(
                    name + " 선생님",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
            ),
            accountEmail: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text(" ");
                  String classroom = snapshot.data.data['class'];
                  return Text(
                    SCHOOL_NAME + " " + classroom + "반",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  );
                }
            ),
            currentAccountPicture: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text(" ");
                String profileImageUrl = snapshot.data.data['profileImageUrl'];
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: profileImageUrl == ''
                    ? Image(image: AssetImage('images/profiledefault.png'))
                    : Image.network(profileImageUrl),
                );
              }
            ),
          );
        }
      ),
    );
  }
  Widget _buildDrawerList(LoginBloc bloc) {
    return Expanded(
      child: FutureBuilder<FirebaseUser>(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          FirebaseUser user = snapshot.data;
          return Column(
            children: <Widget>[
              StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text(" ");
                  String className = snapshot.data.data['class'];
                  return ListTile(
                    title: Text(
                      "야외활동",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherActivityScreen(className: className,)
                        ),
                      );
                    },
                  );
                }
              ),
              _divider(),
              _buildListTile('활동기록', '/teacherlog'),
              _divider(),
              _buildListTile('마이페이지', '/teachermypage'),
              _divider(),
            ],
          );
        }
      ),
    );
  }
  Widget _buildListTile(String listName, String route) {
    return ListTile(
      title: Text(
        listName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.navigate_next),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _logoutDrawer(LoginBloc bloc) {
    return  ListTile(
      title: Text(
        "로그아웃",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        _logoutCheck(bloc);
      },
    );
  }

  Widget _teacherName(String name) {
    return Flexible(
      flex: 2,
      child: Center(
        child: Container(
          width: 150.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFC9EBF7),
                width: 2.0,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              name+ " 선생님",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildReadMe(String name) {
    return Flexible(
      flex: 1,
      child: Text(
        name + " 선생님 안녕하세요.\n"
        "탑승할 차량 번호를 선택해주세요.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }
  Widget _buildDropdownButton() {
    return  Flexible(
      flex: 1,
      child: Container(
        width: 100.0,
        child: FutureBuilder(
          future:  Firestore.instance.collection('Kindergarden').document('hamang').collection('Bus').getDocuments(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            List<String> busList = [];
            snapshot.data.documents.map((DocumentSnapshot document) {
              busList.add(document.documentID.toString());
            }).toList();

            return Center(
              child: DropdownButton(
                value: dropdownValue,
                onChanged: (String value) {
                  setState(() {
                    dropdownValue = value;
                    carNum = busList.indexWhere((num) => num.startsWith(value)) + 1;
                  });
                },
                items: busList.map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                )).toList(),
                hint: Text("운행 차량"),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String teacherName, int carNum) {
    return Flexible(
      flex: 1,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "차량 선택",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFFC9EBF7),
        onPressed: () {
          if(carNum == null) {
            _selectCarNum();
          } else {
            _setBusTeacherName(teacherName, carNum);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeacherBusScreen(carNum: carNum,)
              ),
            );
          }
        },
      ),
    );
  }
  void _selectCarNum() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "운행 차량 선택",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("탑승하는 차량을 확인해 주세요."),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logoutCheck(LoginBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "로그아웃",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("로그아웃 하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                bloc.signOut();
              },
            ),
            CupertinoButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _setBusTeacherName(String teacherName, int busNum) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Bus')
        .document(busNum.toString()+'호차').updateData({
      'teacher': teacherName,
    });
  }
  Widget _buildBackground(MediaQueryData  queryData) {
    return Container(
      width: queryData.size.width,
      child: Image.asset(
        'images/teacherhome.png',
        fit: BoxFit.fill,
      ),
    );
  }
  Widget _divider() {
    return Divider(
      height: 0.5,
      color: Color(0xFFC9EBF7),
    );
  }
}
