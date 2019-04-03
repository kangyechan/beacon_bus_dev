import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ParentProvider.of(context);

    return Scaffold(
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, ParentBloc bloc) {
    return _emailFieled(bloc);
  }

  Widget _emailFieled(ParentBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'you@example.com',
              labelText: 'Email Address',
              errorText: snapshot.error
          ),
        );
      },
    );
  }
}
