import 'package:rxdart/rxdart.dart';
import 'package:beacon_bus/blocs/parent/parent_login_validators.dart';

class ParentBloc extends Object with ParentLoginValidators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  
  Observable<String> get email => _email.stream.transform(validateEmail);
  Observable<String> get password => _password.stream.transform(validatePassword);

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  dispose() {
    _email.close();
    _password.close();
  }
}