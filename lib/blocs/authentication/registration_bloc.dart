import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/repository/repos/auth_repo.dart';
import 'package:progress_soft_app/repository/repos/users_repo.dart';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepo = AuthRepository();
  PhoneAuthCredential? phoneAuthCredential;
  String? verificationId;

  Map<String, String> userInfo = {};

  RegistrationBloc() : super(RegistrationInitial()) {
    on<SendOtp>((event, emit) async {
      emit(RegistrationLoading());

      try {
        _authRepo.verifyPhoneNumber(
            mobileNumber: event.mobileNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              add(OnOtpVerified(credential: credential));
            },
            verificationFailed: (FirebaseAuthException e) {
              add(OnSentOtpError(message: e.message!));
            },
            codeSent: (String verificationId, int? resendToken) {
              add(OnOtpSent(
                  verificationId: verificationId, token: resendToken));
            },
            codeAutoRetrievalTimeout: (String verificationId) {});
      } catch (e) {
        add(OnOtpAuthError(message: 'Failed to verify phone number'));
      }
    });

    on<OnSentOtpError>((event, emit) {
      emit(OtpSentError(message: event.message));
    });

    on<OnOtpSent>((event, emit) {
      emit(OtpSent(verificationId: event.verificationId));
    });

    on<VerifyOtp>(
      (event, emit) async {
        emit(OtpLoading());
        try {
          phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: event.verificationId,
            smsCode: event.otp,
          );

          await _authRepo.auth
              .signInWithCredential(phoneAuthCredential!)
              .then((value) {
            add(OnOtpVerified(credential: phoneAuthCredential!));
          });
        } catch (e) {
          add(OnOtpAuthError(message: 'Failed to verify OTP'));
        }
      },
    );

    on<OnOtpVerified>(
      (event, emit) async {
        try {
          emit(OtpVerified());
        } catch (e) {
          add(OnOtpAuthError(message: 'Failed to verify OTP'));
        }
      },
    );

    on<OnOtpAuthError>(
      (event, emit) {
        emit(OtpFaliure(message: event.message));
      },
    );

    on<RegisterUser>(
      (event, emit) async {
        emit(RegistrationLoading());

        try {
          UserCredential? userCredential;
          await _authRepo.auth
              .signInWithCredential(phoneAuthCredential!)
              .then((value) {
            userCredential = value;
          });

          // UserCredential userCredential =
          //     await _auth.signInWithCredential(phoneAuthCredential!);

          UsersRepository.setNewUserDate(
            userCredential?.user!.uid ?? '',
            event.fullName,
            event.mobileNumber,
            event.age,
            event.gender,
            event.password,
          );

          emit(RegistrationSuccess(message: 'Registration Successful'));
        } catch (e) {
          emit(RegistrationFailure(message: 'Failed to register user: ${e.toString()}'));
        }
      },
    );
  }
}
