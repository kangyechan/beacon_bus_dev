import 'dart:async';

import 'package:beacon_bus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'board_status_screen.dart';
import 'board_yes_or_no.screen.dart';
import '../../blocs/login/login_provider.dart';

class ParentHomeScreen extends StatefulWidget {
  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  List<Widget> pages;
  int _currentIndex = 0;
  Widget currentPage;

  BoardStatusScreen boardStatusScreen;
  BoardYesOrNoScreen boardYesOrNoScreen;

  @override
  void initState() {
    super.initState();
    boardStatusScreen = BoardStatusScreen();
    boardYesOrNoScreen = BoardYesOrNoScreen();
    pages = [boardStatusScreen, boardYesOrNoScreen];
    currentPage = boardStatusScreen;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);
    bloc.getCurrentUserAndSetChildId();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          SCHOOL_NAME,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      drawer: Drawer(
        child: _buildDrawer(bloc),
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: buildBarItems(),
        fixedColor: Colors.yellow,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      currentPage = pages[index];
    });
  }

  Widget _buildDrawer(LoginBloc bloc) {
    return Column(
      children: <Widget>[
        _buildUserAccounts(bloc),
        _buildDrawerList(),
        _divider(),
        _logoutDrawer(bloc),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.5,
      color: Colors.amber,
    );
  }

  Widget _buildDrawerList() {
    return Expanded(
      child: Column(
        children: <Widget>[
          _buildListTile('승하차 기록', '/parentlog'),
          _divider(),
          _buildListTile('마이페이지', '/parentmypage'),
          _divider(),
        ],
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

  Widget _buildUserAccounts(LoginBloc bloc) {
    return FutureBuilder<FirebaseUser>(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          FirebaseUser user = snapshot.data;
          return Container(
            height: 200.0,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              margin: EdgeInsets.all(0.0),
              accountName: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('Users')
                      .document(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text(" ");
                    String name = snapshot.data.data['name'];
                    return Text(
                      name + " 학부모",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
              accountEmail: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('Users')
                      .document(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text(" ");
                    String classroom = snapshot.data.data['class'];
                    return Text(
                      SCHOOL_NAME + " " + classroom + "반",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    );
                  }),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: StreamBuilder(
                  stream: bloc.childId,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    String childId = snapshot.data;
                    return FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection('Kindergarden')
                          .document('hamang')
                          .collection('Children')
                          .document(childId)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('images/profiledefault.png'),
                              ),
                              color: Colors.white,
                            ),
                          );
                        }

                        if (snapshot.data.data['profileImageUrl'] == null
                        || snapshot.data.data['profileImageUrl'] == "") {
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('images/profiledefault.png'),
                              ),
                              color: Colors.white,
                            ),
                          );
                        }
                        return Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                snapshot.data.data['profileImageUrl'],
                              ),
                            ),
                            color: Colors.white,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget _logoutDrawer(LoginBloc bloc) {
    return ListTile(
      title: Text(
        "로그아웃",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => showLogOutDialog(context, bloc),
    );
  }

  showLogOutDialog(BuildContext context, LoginBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(bottom: 200.0),
          child: CupertinoAlertDialog(
            title: Text(
              "알림",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("로그아웃하시겠습니까?"),
            actions: <Widget>[
              CupertinoButton(
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: bloc.signOut),
              CupertinoButton(
                child: Text(
                  '취소',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> buildBarItems() {
    final List<BottomNavigationBarItem> list = [];
    list.add(BottomNavigationBarItem(
        icon: Icon(Icons.directions_bus),
        title: Text("승하차 상태", style: TextStyle(fontSize: 12.0))));
    list.add(BottomNavigationBarItem(
        icon: Icon(Icons.directions_run),
        title: Text("탑승유무", style: TextStyle(fontSize: 12.0))));
    return list;
  }
}
