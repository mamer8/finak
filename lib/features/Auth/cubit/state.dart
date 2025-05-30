abstract class LoginState {}

class LoginStateInitial extends LoginState {}
class SendCodeLoading extends LoginState {}

class OnSmsCodeSent extends LoginState {
  String smsCode;
  OnSmsCodeSent(this.smsCode);
}

class CheckCodeInvalidCode extends LoginState {}

class CheckCodeSuccessfully extends LoginState {}

class CheckCodeErrorfully extends LoginState {}
class FailureLoginState extends LoginState {}
class LoadingLoginState extends LoginState {}
class SuccessLoginState extends LoginState {}