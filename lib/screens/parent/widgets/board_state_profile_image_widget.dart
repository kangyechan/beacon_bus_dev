import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardStateProfileImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ParentBloc parentBloc = ParentProvider.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: StreamBuilder<String>(
        stream: parentBloc.childId,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          String childId = snapshot.data;

          return FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance
                .collection('Kindergarden')
                .document('hamang')
                .collection('Children')
                .document(childId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('images/profiledefault.png'),
                  ),
                ),
              );

              if (snapshot.data.data['profileImageUrl'] == null ||
                  snapshot.data.data['profileImageUrl'] == "") {
                return Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('images/profiledefault.png'),
                    ),
                  ),
                );
              }
              return Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(snapshot.data.data['profileImageUrl']),
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}
