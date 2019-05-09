import 'dart:io';

import 'package:beacon_bus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TeacherMyPageScreen extends StatefulWidget {

  @override
  _TeacherMyPageScreenState createState() => _TeacherMyPageScreenState();
}

class _TeacherMyPageScreenState extends State<TeacherMyPageScreen> {

  String profileImageUrl;
  String className = '';
  String phoneNumber = '';
  File _profileImage;
//  final FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController _classNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _classNameController.text = USER_CLASS;
    _phoneNumberController.text = USER_ID;
  }

//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      _profileImage = image;
//    });
//  }

//  void _editHandle(String name, String price, String description) {
//    if(name != '' && price != '' && description != '') {
//      Firestore.instance.collection('product').document(idtime).updateData({
//        'name': name,
//        'price': int.tryParse(price),
//        'imageurl': profileImageUrl,
//      }).then((contents) {
//        Navigator.popAndPushNamed(context, '/home');
//        dispose();
//      });
//    }
//  }

//  Future uploadImage() async{
//    if (_profileImage != null) {
//      final StorageReference fireBaseStorageRef =
//      FirebaseStorage.instance.ref().child('productImage/$idTime');
//      final StorageUploadTask task =
//      fireBaseStorageRef.putFile(_profileImage);
//      profileImageUrl = await (await task.onComplete).ref.getDownloadURL();
//    } else {
//      profileImageUrl = product.imageUrl;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Container(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  _buildImageSection(queryData),
                  _buildNameSection(),
                  _buildClassSection(),
                  _buildPhoneSection(),
                  _buildButton(),
                ],
              )
          ),
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

  Widget _buildImageSection(MediaQueryData queryData) {
    return Container(
      width: queryData.size.width,
      height: queryData.size.height * (0.4),
      child: Image.asset(
        'images/adddefault.JPG',
        fit: BoxFit.contain
      ),
    );
  }

  Widget _buildNameSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: USER_NAME,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildClassSection() {
    return Container();
  }

  Widget _buildPhoneSection() {
    return Container();
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

              },
            ),
          ),
        ),
      ],
    );
  }
}
