import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/screens/parent/widgets/board_state_profile_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

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
      return Column(
        children: <Widget>[
          Container(
            width: 300.0,
            height: 300.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                BoardStateProfileImageWidget(),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    '개인 이동',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            width: 300.0,
            height: 300.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            child: Column(
              children: <Widget>[
                BoardStateProfileImageWidget(),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: state == 'unknown'
                      ? SizedBox.shrink()
                      : FutureBuilder<DocumentSnapshot>(
                          future: Firestore.instance
                              .collection('Kindergarden')
                              .document('hamang')
                              .collection('Bus')
                              .document("$busNum호차")
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Text('...');
                            String teacher = snapshot.data.data['teacher'];
                            return Text(
                              '$teacher 선생님',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white),
                            );
                          }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: state == 'unknown'
                      ? SizedBox.shrink()
                      : Text(
                          '$changeStateItem',
                          style: TextStyle(
                            fontSize: 18.0,
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
                Text(
                  state == 'unknown' ? "미탑승" : "탑승중",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
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
                      "오늘은 ${protector}가(이) 기다립니다",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  showChangeProtectorDialog(BuildContext context, LoginBloc bloc) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: ['엄마', '아빠', '형', '누나', '이모', '삼촌']),
        hideHeader: true,
        title: Text(
          "보호자",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onConfirm: (Picker picker, List value) {
          final String selectedCategoryForAdd = picker.getSelectedValues()[0];
          bloc.changeProtector(selectedCategoryForAdd);
        }).showDialog(context);
  }
}
