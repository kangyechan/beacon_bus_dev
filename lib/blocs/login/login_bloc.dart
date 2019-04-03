import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/login/login_validators.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginBloc extends Object with LoginValidators {
  BuildContext _context;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Observable<String> get email => _email.stream.transform(validateEmail);
  Observable<String> get password => _password.stream.transform(validatePassword);
  Observable<String> get submitValid => Observable.combineLatest2(email, password, (e, p) => "" + e + p);

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;
    _auth.signInWithEmailAndPassword(email: validEmail, password: validPassword)
        .then((FirebaseUser user) {
      Firestore.instance.collection('Users').document(user.uid).get().then((snapshot) {
        String userType = snapshot.data['type'];
        if (_context != null) {
          if (userType == "parent") Navigator.pushNamed(_context, '/parent');
          else if (userType == "teacher") Navigator.pushNamed(_context, '/teacher');
        }

      });
    });
  }

  setContext(BuildContext context) {
    _context = context;
  }

  dispose() {
    _email.close();
    _password.close();
  }
}