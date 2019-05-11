import 'dart:async';
import 'dart:io';

import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class TeacherMyPageScreen extends StatefulWidget {

  @override
  _TeacherMyPageScreenState createState() => _TeacherMyPageScreenState();
}

class _TeacherMyPageScreenState extends State<TeacherMyPageScreen> {

  File _profileImage;
  String name;
  String className;
  String phoneNumber;
  String profileImageUrl;
  String uid;

  final FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController _classNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  void _editHandle(String className, String phoneNumber, String profileImageUrl) {
    print(className);
    print(phoneNumber);
    print(profileImageUrl);
    if(className != '' && phoneNumber != '' && profileImageUrl != '') {
      Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(uid).updateData({
        'class': className,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
      }).then((contents) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "상태 변경",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("\n수정되었습니다."),
              actions: <Widget> [
                CupertinoButton(
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color: Color(0xFF1EA8E0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/teacher');
                  },
                ),
              ],
            );
          });
      });
    }
  }

  Future uploadImage() async{
    if (_profileImage != null) {
      final StorageReference fireBaseStorageRef =
      FirebaseStorage.instance.ref().child('teacherImage/$uid');
      final StorageUploadTask task =
      fireBaseStorageRef.putFile(_profileImage);
      profileImageUrl = await (await task.onComplete).ref.getDownloadURL();
    } else {
      profileImageUrl = profileImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final bloc = LoginProvider.of(context);
    bloc.setContext(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: FutureBuilder<FirebaseUser>(
          future: bloc.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            FirebaseUser user = snapshot.data;
            return Container(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text(" ");
                      name = snapshot.data.data['name'];
                      className = snapshot.data.data['class'];
                      phoneNumber = snapshot.data.data['phoneNumber'];
                      profileImageUrl = snapshot.data.data['profileImageUrl'];
                      uid = snapshot.data.documentID;
                      return ListView(
                        children: <Widget>[
                          SizedBox(height: 20.0,),
                          _buildImageSection(queryData),
                          _buildCameraSection(),
                          SizedBox(height: 20.0,),
                          _buildNameSection(name),
                          SizedBox(height: 30.0,),
                          _buildClassSection(className),
                          SizedBox(height: 30.0,),
                          _buildPhoneSection(phoneNumber),
                          SizedBox(height: 50.0,),
                          _buildButton(),
                        ],
                      );
                    }
                  )
              ),
            );
          }
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

  Widget _buildImageSection(MediaQueryData queryData) {
    Widget section;
    if(profileImageUrl == '') {
      section = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _profileImage == null
                ? AssetImage(
                'images/profiledefault.png',
              )
                : Image.file(
              _profileImage,
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        height: 180.0,
      );
    } else {
      section = Container(
        margin: EdgeInsets.symmetric(horizontal: 80.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _profileImage == null
                ? NetworkImage(
              profileImageUrl,
            )
                : Image.file(
              _profileImage,
            ),
            fit: BoxFit.fitHeight,
          )
        ),
        height: 180.0,
      );
    }
    return section;
  }

  Widget _buildCameraSection() {
    return Container(
      child: FlatButton(
        color: Colors.white,
        child: Icon(
          Icons.camera_alt,
          color: Color(0xFF1EA8E0),
        ),
        onPressed: () {
          print('camera button');
          getImage();
        },
      ),
    );
  }

  Widget _buildNameSection(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Text(
        name +" 선생님",
        style: TextStyle(
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildClassSection(String className) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: className + '반',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
              controller: _classNameController,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top:15.0),
            child: Icon(
              Icons.create,
              size: 20.0,
              color: Color(0xFF1EA8E0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(String phoneNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: phoneNumber,
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
              controller: _phoneNumberController,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top:15.0),
            child: Icon(
              Icons.create,
              size: 20.0,
              color: Color(0xFF1EA8E0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: FlatButton(
              child: Text(
                "수정",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Color(0xFFC9EBF7),
              onPressed: () {
                if(_classNameController.text == '') _classNameController.text = className+'반';
                if(_phoneNumberController.text == '') _phoneNumberController.text = phoneNumber;
                uploadImage().then((push){
                  _editHandle(_classNameController.text.substring(0, _classNameController.text.length-1),
                      _phoneNumberController.text, profileImageUrl);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: FlatButton(
              child: Text(
                "취소",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Color(0xFFC9EBF7),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
