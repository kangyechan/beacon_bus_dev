import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardStateWidget extends StatelessWidget {
  final Color color;
  final String busNum;
  final String changeStateItem;
  final String state;

  BoardStateWidget({this.state, this.color, this.busNum, this.changeStateItem});

  @override
  Widget build(BuildContext context) {

    LoginBloc loginBloc = LoginProvider.of(context);
    if (state == "notboard") {
      return Container(
        width: 300.0,
        height: 300.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150.0),
          color: color,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'images/background.JPG',
                  width: 100.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text('개인 이동', style: TextStyle(color: Colors.black, fontSize: 18.0),),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            width: 300.0,
            height: 300.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150.0),
              color: color,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Image.asset(
                      'images/background.JPG',
                      width: 100.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: state == 'unknown' ? Opacity(opacity: 0,) : FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance.collection('Kindergarden')
                          .document('hamang').collection('Bus').document(
                          "$busNum호차")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('...');
                        String teacher = snapshot.data.data['teacher'];
                        return Text('$teacher 선생님', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),);
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: state == 'unknown' ? Opacity(opacity: 0,) : Text('$changeStateItem', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(state == 'unknown' ? "미탑승" : "탑승중", style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18.0),),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0,),
          FlatButton(
            child: Text('처음으로', style: TextStyle(color: Colors.white, fontSize: 20.0),),
            onPressed: null
          ),
          _buildProtectorText(context, loginBloc),
        ],
      );
    }
  }

  Widget _buildProtectorText(BuildContext context, LoginBloc bloc) {
    return GestureDetector(
      onTap: () => showChangeProtectorDialog(context, bloc),
      child: StreamBuilder<String>(
          stream: bloc.childId,
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
                String protector = snapshot.data.data['protector'];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "오늘은 ${protector}가 기다립니다",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  showChangeProtectorDialog(BuildContext context, LoginBloc bloc) {
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
            content: Text("마중나올 보호자를 변경하세요."),
            actions: <Widget>[
              StreamBuilder(
                stream: bloc.protector,
                builder: (context, snapshot) {
                  return CupertinoTextField(
                    onChanged: bloc.onChangeProtector,
                    placeholder: "보호자 관계 ex:엄마, 아빠, 오빠",
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
                    bloc.changeProtector();
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
