part of 'login_bloc.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String message;

  LoginSuccess({required this.message});
}

final class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
}

final class PasswordIncorrect extends LoginState {
  final String message;

  PasswordIncorrect({required this.message});
}

final class UserNotRegistered extends LoginState {
  final String message;

  UserNotRegistered({required this.message});
}

final class LoggingOut extends LoginState {}

final class LoggedOut extends LoginState {}
