import 'dart:async';

import 'package:beacon_bus/blocs/parent/parent_date_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentBloc extends Object with ParentDateHelpers {

  Future<FirebaseUser> get user => FirebaseAuth.instance.currentUser();

  void changeBoardingStatus(String selectedDate) async {
    FirebaseUser currentUser = await user;
    // DB에 저장되어 있는 안타는 날 리스트를 받아온다
    Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(currentUser.uid).get().then((documentSnapshot) {
      List<String> notBoardingDateList = List<String>.from(documentSnapshot.data['notBoardingDateList']);
      // 리스트에 이미 있으면 제거 없으면 추가
      if (notBoardingDateList.contains(selectedDate)) {
        notBoardingDateList.remove(selectedDate);
      } else {
        notBoardingDateList.add(selectedDate);
      }
      // 업데이트 된 리스트로 DB에 추가
      Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(currentUser.uid).setData({
        'notBoardingDateList': notBoardingDateList,
      }, merge: true);
    });
  }
}