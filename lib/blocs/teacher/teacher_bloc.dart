import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherBloc {

  Future<FirebaseUser> get user => FirebaseAuth.instance.currentUser();

  void getBoardList() async {
    FirebaseUser currentUser = await user;

    Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(currentUser.uid).get().then((documentSnapshot) {
//      String busNum = Map.from(documentSnapshot.data['busNum']);
    });
  }


  void changeBoardingStatus(String selectedDate) async {

    Firestore.instance.collection('Kindergarden').document('hamang').collection('Bus').getDocuments().then((QuerySnapshot querySnapshot) {
      List<String> busList = querySnapshot.documents.map((bus) {
      return bus.documentID;
    });
    // 리스트에 이미 있으면 제거 없으면 추가
  });
  }
}