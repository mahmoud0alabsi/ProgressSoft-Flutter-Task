part of 'registration_bloc.dart';

abstract class RegistrationEvent {}

class SendOtp extends RegistrationEvent {
  final String mobileNumber;
  
  SendOtp({required this.mobileNumber});
}

class OnOtpSent extends RegistrationEvent {
  final String verificationId;
  final int? token;
  
  OnOtpSent({required this.verificationId, required this.token});
}

class OnSentOtpError extends RegistrationEvent {
  final String message;
  
  OnSentOtpError({required this.message});
}

class VerifyOtp extends RegistrationEvent {
  final String otp;
  final String verificationId;
  
  VerifyOtp({required this.otp, required this.verificationId});
}

class OnOtpAuthError extends RegistrationEvent {
  final String message;
  
  OnOtpAuthError({required this.message});
}

class OnOtpVerified extends RegistrationEvent {
  final AuthCredential credential;
  final UserCredential? userCredential;

  OnOtpVerified({required this.credential, this.userCredential});
}

class RegisterUser extends RegistrationEvent {
  final String fullName;
  final String mobileNumber;
  final int age;
  final String gender;
  final String password;
  
  RegisterUser({required this.fullName, required this.mobileNumber, required this.age, required this.gender, required this.password});
}