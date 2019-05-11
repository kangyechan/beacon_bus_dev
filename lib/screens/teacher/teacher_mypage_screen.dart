import 'dart:async';
import 'dart:io';

import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
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
    if(className != '' && phoneNumber != '' && profileImageUrl != null) {
      Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(uid).updateData({
        'class': className,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
      }).then((contents) {
        Navigator.popAndPushNamed(context, '/teacher');
        dispose();
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
                      uid = snapshot.data.data['profileImageUrl'];
                      return ListView(
                        children: <Widget>[
                          SizedBox(height: 30.0,),
                          _buildImageSection(queryData, profileImageUrl),
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

  Widget _buildImageSection(MediaQueryData queryData, String url) {
    if(url == '') url = null;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      width: queryData.size.width * (0.2),
      height: queryData.size.height * (0.2),
      margin: EdgeInsets.symmetric(horizontal: 100.0),
      child: url == null
          ? Image(
          image: AssetImage(
            'images/profiledefault.png',
          ),
          fit: BoxFit.fitHeight,)
          : Image.network(
          url,
          fit: BoxFit.fitHeight,),
    );
  }

  Widget _buildCameraSection() {
    return Container(
      child: FlatButton(
        color: Colors.white,
        child: Icon(
          Icons.camera_alt,
          color: Color(0xFF1EA8E0),
        ),
        onPressed: () => getImage()),
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
    _classNameController.text = className+"반";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
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
    _phoneNumberController.text = phoneNumber;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '- 없이 숫자만',
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
                uploadImage().then((push){
                  _editHandle(_classNameController.text.substring(0, _classNameController.text.length - 1),
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
