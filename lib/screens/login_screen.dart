import 'package:flutter/material.dart';
import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    final bloc = LoginProvider.of(context);
    init(context, bloc);
    return Scaffold(
      body: _buildBody(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, LoginBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 200.0,),
          Image.asset('images/background.JPG'),
          _emailField(bloc),
          _passwordField(bloc),
          _loginButton(bloc),
        ],
      ),
    );
  }

  Widget _emailField(LoginBloc bloc) {
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

  Widget _passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _loginButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('로그인'),
          color: Theme.of(context).accentColor,
          onPressed: () {
            if (snapshot.hasData) {
//              print('hi');
              LoginProvider.of(context).setContext(context);
              bloc.submit();
            }
          }
        );
      },
    );
  }

  void init(BuildContext context, LoginBloc bloc) async {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        print(user);
      }
    });
  }
}
