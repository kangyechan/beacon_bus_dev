import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/teacher_bloc.dart';
export 'package:beacon_bus/blocs/teacher_bloc.dart';


class TeacherProvider extends InheritedWidget {
  final TeacherBloc bloc;

  TeacherProvider({Key key, @required Widget child,})
      : bloc = TeacherBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(TeacherProvider oldWidget) => true;

  static TeacherBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TeacherProvider) as TeacherProvider).bloc;
  }
}