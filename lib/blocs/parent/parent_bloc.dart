import 'dart:async';

import 'package:beacon_bus/blocs/parent/parent_date_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class ParentBloc extends Object with ParentDateHelpers {

  SharedPreferences prefs;
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  ParentBloc() {
    getCurrentUserAndSetChildId();
    changeSelectedDate(DateTime.now());
  }

  final _selectedDate = BehaviorSubject<DateTime>();
  final _childId = BehaviorSubject<String>();

  Observable<DateTime> get selectedDate => _selectedDate.stream;
  Observable<String> get childId => _childId.stream;

  Function(DateTime) get changeSelectedDate => _selectedDate.sink.add;
  Function(String) get setChildId => _childId.sink.add;

  void changeBoardingStatus(String selectedDate) async {
    // DB에 저장되어 있는 안타는 날 리스트를 받아온다
    FirebaseUser user = await currentUser;
    Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).get().then((documentSnapshot) {
      String childId = documentSnapshot.data['childId'];
      List<String> notBoardingDateList = List<String>.from(documentSnapshot.data['notBoardingDateList']);
      // 리스트에 이미 있으면 제거 없으면 추가
      if (notBoardingDateList.contains(selectedDate)) {
        notBoardingDateList.remove(selectedDate);
      } else {
        notBoardingDateList.add(selectedDate);
      }
      // 업데이트 된 리스트로 DB에 추가
      Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).setData({
        'notBoardingDateList': notBoardingDateList,
      }, merge: true).then((done){
        Firestore.instance.collection('Kindergarden').document('hamang').collection('Children').document(childId).setData({
          'notBoardingDateList': notBoardingDateList,
        }, merge: true);
      });
    });
  }

  getCurrentUserAndSetChildId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // childId를 가져와서 Stream에 넣는다..
    Firestore.instance.collection('Kindergarden').document('hamang').collection('Users').document(user.uid).get().then((documentSnapshot) {
      String childId = documentSnapshot.data['childId'];
      setChildId(childId);
    });
  }

  dispose() {
    _selectedDate.close();
    _childId.close();
  }
}