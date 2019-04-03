import 'package:beacon_bus/blocs/teacher_provider.dart';
import 'package:beacon_bus/screens/teacher_home.dart';
import 'package:beacon_bus/screens/user_home.dart';
import 'package:flutter/material.dart';

class BeaconBusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TeacherProvider(
      child: MaterialApp(
        title: 'School Bus',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: THomePage(),
        routes: {

        },
      ),
    );
  }
}