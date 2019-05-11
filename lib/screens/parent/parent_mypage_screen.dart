import 'dart:async';
import 'dart:io';

import 'package:beacon_bus/blocs/parent/parent_bloc.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_hud_v2/progress_hud.dart';

class ParentMyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ParentBloc parentBloc = ParentProvider.of(context);
    parentBloc.setContext(context);

    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context, parentBloc),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        '마이페이지',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    );
  }

  Widget _buildBody(BuildContext context, ParentBloc bloc) {
    return Container(
      width: 1000.0,
      margin: EdgeInsets.only(top: 30.0),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _buildChildImageView(bloc),
              _buildParentName(bloc),
              _buildParentPhoneNumber(bloc),
              SizedBox(height: 75.0,),
              _buildEditButton(context, bloc),
            ],
          ),
          _buildProgressHud(bloc),
        ],
      ),
    );
  }

  Widget _buildChildImageView(ParentBloc parentBloc) {
    return GestureDetector(
      onTap: () {
        imagePicker(parentBloc);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          StreamBuilder<String>(
            stream: parentBloc.childId,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              String childId = snapshot.data;
              return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('Kindergarden')
                      .document('hamang')
                      .collection('Children')
                      .document(childId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    String profileImageUrl =
                        snapshot.data.data['profileImageUrl'];
                    return StreamBuilder<File>(
                        stream: parentBloc.profileImageForAdd,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: profileImageUrl != ""
                                      ? NetworkImage(profileImageUrl)
                                      : AssetImage('images/adddefault.JPG'),
                                ),
                                color: Colors.white,
                              ),
                            );
                          } else {
                            File image = snapshot.data;
                            return Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(image),
                                ),
                                color: Colors.white,
                              ),
                            );
                          }
                        });
                  });
            },
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            margin: EdgeInsets.fromLTRB(150.0, 150.0, 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentName(ParentBloc parentBloc) {
    return FutureBuilder<FirebaseUser>(
        future: parentBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          FirebaseUser user = snapshot.data;

          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Kindergarden')
                .document('hamang')
                .collection('Users')
                .document(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              String userName = snapshot.data.data['name'];
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  "$userName 학부모",
                  style: TextStyle(fontSize: 25.0),
                ),
              );
            },
          );
        });
  }

  Widget _buildParentPhoneNumber(ParentBloc parentBloc) {
    return FutureBuilder<FirebaseUser>(
        future: parentBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          FirebaseUser user = snapshot.data;

          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Kindergarden')
                .document('hamang')
                .collection('Users')
                .document(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              String phoneNumber = snapshot.data.data['phoneNumber'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$phoneNumber",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.yellow.shade800,
                      size: 20.0,
                    ),
                    onPressed: () =>
                        showChangePhoneNumberDialog(context, parentBloc),
                  )
                ],
              );
            },
          );
        });
  }

  Widget _buildEditButton(BuildContext context, ParentBloc bloc) {
    return Container(
      padding: EdgeInsets.all(17.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow
      ),
//      color: Colors.yellow,
      child: FlatButton(
        child: Text('수정하기'),
        onPressed: () {
          showEditConfirmDialog(context, bloc);
        },
      ),
    );
  }

  Widget _buildProgressHud(ParentBloc bloc) {
    return StreamBuilder<Object>(
        stream: bloc.loading,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          bool loading = snapshot.data;
          print(loading);
          double opacity = 0;
          opacity = loading ? 1.0 : 0.0;
          return Opacity(
            opacity: opacity,
            child: ProgressHUD(
              backgroundColor: Colors.black12,
              color: Colors.white,
              containerColor: Theme.of(context).accentColor,
              borderRadius: 5.0,
              text: '',
            ),
          );
        });
  }

  Future imagePicker(ParentBloc parentBloc) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    parentBloc.setProfileImageForAdd(image);
  }

  showEditConfirmDialog(BuildContext context, ParentBloc parentBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "알림",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("수정하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  parentBloc.changeProfileImage();
                }),
            CupertinoButton(
                child: Text(
                  '취소',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }


  showChangePhoneNumberDialog(BuildContext context, ParentBloc parentBloc) {
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
            content: Text("전화번호를 변경하세요"),
            actions: <Widget>[
              StreamBuilder(
                stream: parentBloc.phoneNumber,
                builder: (context, snapshot) {
                  return CupertinoTextField(
                    onChanged: parentBloc.onChangePhoneNumber,
                    placeholder: "-제외 전화번호만",
                    textAlign: TextAlign.center,
                    autofocus: true,
                  );
                },
              ),
              CupertinoButton(
                  child: Text(
                    '변경',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    parentBloc.changePhoneNumber();
                  }),
              CupertinoButton(
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
