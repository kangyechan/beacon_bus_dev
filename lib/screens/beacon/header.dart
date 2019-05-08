//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

import 'dart:io';

import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Header extends StatefulWidget {
  const Header(
      {Key key, this.regionIdentifier, this.running, this.onStart, this.onStop})
      : super(key: key);

  final String regionIdentifier;
  final bool running;
  final ValueChanged<BeaconRegion> onStart;
  final VoidCallback onStop;

  @override
  _HeaderState createState() => new _HeaderState();
}

class _HeaderState extends State<Header> {
  FormType _formType;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _formType = Platform.isIOS ? FormType.iBeacon : FormType.generic;
  }

  void _onTapSubmit() {
    if (widget.running) {
      widget.onStop();
    } else {
      if (!_formKey.currentState.validate()) {
        return;
      }
      List<dynamic> ids = [];

      BeaconRegion region =
      BeaconRegion(identifier: widget.regionIdentifier, ids: ids);

      // ignore: missing_enum_constant_in_switch
      switch (_formType) {
        case FormType.iBeacon:
          region = BeaconRegionIBeacon.from(region);
          break;
      }

      widget.onStart(region);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: _formType == FormType.generic
                ? _FormGeneric(
              running: widget.running,
            )
                : _FormIBeacon(
              running: widget.running,
            ),
          ),
          _Button(
            running: widget.running,
            onTap: () {
              widget.running ? _showCheckDialog() : _startCheck(3);
            },
          ),
        ],
      ),
    );
  }
  void _startCheck(int carNum) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "운행 시작",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(carNum.toString() + "호차 운행을 시작하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "운행 시작",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onTapSubmit();
              }
            ),
            CupertinoButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "운행 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("모든 학생의 상태를 확인하셨나요?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "확인완료",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showCloseDialog(context);
              },
            ),
            CupertinoButton(
              child: Text(
                "아니오",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showCloseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "운행 종료",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("운행을 정말 종료하시겠습니까?"),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "운행 종료",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                _onTapSubmit();
                _setBusTeacherName('', 3);
                Navigator.of(context).pop();
                dispose();
                Navigator.pushNamed(context, '/teacher');
              },
            ),
            CupertinoButton(
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(0xFF1EA8E0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _setBusTeacherName(String teacherName, int busNum) {
    Firestore.instance
        .collection('Kindergarden')
        .document('hamang')
        .collection('Bus')
        .document(busNum.toString()+'호차').updateData({
      'teacher': teacherName,
    });
  }
}

class _Button extends StatelessWidget {
  _Button({
    @required this.running,
    @required this.onTap,
  });

  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        color: Color(0xFFC9EBF7),
        padding: EdgeInsets.all(10.0),
        child: Text(
          running ? '운행 종료' : '운행 시작',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }


}

enum FormType { generic, iBeacon }

class _FormGeneric extends StatelessWidget {
  const _FormGeneric({
    Key key,
    this.running,
  }) : super(key: key);

  final bool running;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _FormIBeacon extends StatelessWidget {
  const _FormIBeacon({
    Key key,
    this.running,
  }) : super(key: key);

  final bool running;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}