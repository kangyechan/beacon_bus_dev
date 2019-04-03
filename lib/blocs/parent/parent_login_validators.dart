import 'dart:async';

class ParentLoginValidators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);
      } else {
        sink.addError('이메일 형식을 확인해주세요');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 5) {
        sink.add(password);
      } else {
        sink.addError('비밀번호는 5자리 이상이어야 합니다');
      }
    }
  );
}