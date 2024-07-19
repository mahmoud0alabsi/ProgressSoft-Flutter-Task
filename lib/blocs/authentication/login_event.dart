part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginWithCredentials extends LoginEvent {
  final String mobileNumber;
  final String password;

  LoginWithCredentials({required this.mobileNumber, required this.password});
}

class OnLoginError extends LoginEvent {
  final String message;

  OnLoginError({required this.message});
}

class OnLoginSuccess extends LoginEvent {
  final String message;

  OnLoginSuccess({required this.message});
}

class OnPasswordIncorrect extends LoginEvent {
  final String message;

  OnPasswordIncorrect({required this.message});
}

class OnUserNotRegistered extends LoginEvent {
  final String message;

  OnUserNotRegistered({required this.message});
}

class StoreLoginCredentials extends LoginEvent {
  final String mobileNumber;
  final String password;

  StoreLoginCredentials({required this.mobileNumber, required this.password});
}

class AutoLogin extends LoginEvent {}

class Logout extends LoginEvent {}

class OnLogoutSuccess extends LoginEvent {}