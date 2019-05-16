import 'dart:async';
import 'dart:io';

import 'package:beacon_bus/blocs/parent/parent_date_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class ParentBloc extends Object with ParentDateHelpers {
  SharedPreferences prefs;
  BuildContext _context;

  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  ParentBloc() {
    changeSelectedDate(DateTime.now());
    getCurrentUserAndSetChildId();
  }

  final _selectedDate = BehaviorSubject<DateTime>();
  final _childId = BehaviorSubject<String>();
  final _profileImageForAdd = BehaviorSubject<File>();
  final _phoneNumber = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>();

  Observable<DateTime> get selectedDate => _selectedDate.stream;

  Observable<String> get childId => _childId.stream;

  Observable<File> get profileImageForAdd => _profileImageForAdd.stream;

  Observable<String> get phoneNumber => _phoneNumber.stream;

  Observable<bool> get loading => _loading.stream;

  Function(DateTime) get changeSelectedDate => _selectedDate.sink.add;

  Function(String) get setChildId => _childId.sink.add;

  Function(File) get setProfileImageForAdd => _profileImageForAdd.sink.add;

  Function(String) get onChangePhoneNumber => _phoneNumber.sink.add;

  Function(bool) get setLoadingState => _loading.sink.add;

  void changeBoardingStatus(String selectedDate) async {
    // DB에 저장되어 있는 안타는 날 리스트를 받아온다
    FirebaseUser user = await currentUser;
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Users')
        .document(user.uid)
        .get()
        .then((documentSnapshot) {
      String childId = documentSnapshot.data['childId'];
      List<String> notBoardingDateList =
          List<String>.from(documentSnapshot.data['notBoardingDateList']);
      // 리스트에 이미 있으면 제거 없으면 추가
      if (notBoardingDateList.contains(selectedDate)) {
        notBoardingDateList.remove(selectedDate);
      } else {
        notBoardingDateList.add(selectedDate);
      }
      // 업데이트 된 리스트로 DB에 추가
      Firestore.instance
          .collection('Kindergarden')
          .document('hamang')
          .collection('Users')
          .document(user.uid)
          .setData({
        'notBoardingDateList': notBoardingDateList,
      }, merge: true).then((done) {
        Firestore.instance
            .collection('Kindergarden')
            .document('hamang')
            .collection('Children')
            .document(childId)
            .setData({
          'notBoardingDateList': notBoardingDateList,
        }, merge: true);
      });
    });
  }

  getCurrentUserAndSetChildId() async {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      Firestore.instance
          .collection('Kindergarden')
          .document('hamang')
          .collection('Users')
          .document(user.uid)
          .get()
          .then((documentSnapshot) {
        String childId = documentSnapshot.data['childId'];
        setChildId(childId);
      });
    });
    // childId를 가져와서 Stream에 넣는다..
  }

  Future<Null> changeProfileImage() async {

    // 1. image file을 스트림으로 받아온다
    File file = _profileImageForAdd.value;
    FirebaseUser user = await currentUser;
    String imageUrl;
    // 2. image file이 null이 아니면 storage에 업로드 한다
    if (file != null) {
      setLoadingState(true);
      final StorageReference imagesRef =
      FirebaseStorage.instance.ref().child('childrenImage/${user.uid}');
      StorageUploadTask uploadTask = imagesRef.putFile(file);

      // 3. 업로드한 파일의 url을 callback으로 받는다.
      await (await uploadTask.onComplete)
          .ref
          .getDownloadURL()
          .then((dynamic url) {
        imageUrl = url;
        // 4. callback으로 받은 파일의 url을 사용해서 DB에 저장한다.
        Firestore.instance
            .collection('Kindergarden')
            .document('hamang')
            .collection('Children')
            .document(_childId.value).updateData({"profileImageUrl": imageUrl}).then((done) {
              setLoadingState(false);
              setProfileImageForAdd(null);
        });
      });
    }
  }

  Future<Null> changePhoneNumber() async {
    FirebaseUser user = await currentUser;

    Firestore.instance.collection('Kindergarden').document('hamang').collection(
        'Users').document(user.uid).updateData({'phoneNumber': _phoneNumber.value}).then((done) {
      Firestore.instance.collection('Kindergarden').document('hamang').collection(
          'Children').document(_childId.value).updateData({'phoneNumber': _phoneNumber.value}).then((done) => Navigator.pop(_context));
    });
  }

  setContext(BuildContext context) {
    _context = context;
  }


  dispose() {
    _selectedDate.close();
    _childId.close();
    _profileImageForAdd.close();
    _phoneNumber.close();
    _loading.close();
  }
}
