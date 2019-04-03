import 'package:beacon_bus/blocs/teacher/teacher_provider.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:beacon_bus/screens/parent/parent_login_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_home.dart';
import 'package:beacon_bus/screens/parent/user_home.dart';
import 'package:flutter/material.dart';

class BeaconBusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ParentProvider(
      child: TeacherProvider(
        child: MaterialApp(
          title: 'School Bus',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
          ),
          home: ParentLoginScreen(),
          routes: {

          },
        ),
      ),
    );
  }
}