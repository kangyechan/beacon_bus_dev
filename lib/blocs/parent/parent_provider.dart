import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_bloc.dart';
export 'package:beacon_bus/blocs/parent/parent_bloc.dart';

class ParentProvider extends InheritedWidget {
  final ParentBloc bloc;

  ParentProvider({Key key, @required Widget child,})
      : bloc = ParentBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ParentProvider old) => true;

  static ParentBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ParentProvider) as ParentProvider).bloc;
  }

}