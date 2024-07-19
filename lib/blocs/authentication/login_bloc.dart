import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/repository/models/CustomUser.dart';
import 'package:progress_soft_app/repository/repos/users_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginWithCredentials>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      emit(LoginLoading());
      try {
        // Check if user exists
        CustomUser user = await UsersRepository.checkIfUserExists(
            event.mobileNumber, event.password);

        if (user.uid != '') {
          // User exists, check password
          if (event.password == user.password) {
            // Correct password, log in user
            add(OnLoginSuccess(message: 'Login successful'));
            add(StoreLoginCredentials(
                mobileNumber: event.mobileNumber, password: event.password));
          } else {
            // Incorrect password
            add(OnPasswordIncorrect(
                message: prefs.getString('password_incorrect_message') ??
                    'Incorrect password'));
          }
        } else {
          // User does not exist
          add(OnUserNotRegistered(
              message: prefs.getString('user_not_registered_message') ??
                  'User not registered'));
        }
      } catch (e) {
        emit(LoginFailure(message: 'Failed to login'));
      }
    });

    on<OnLoginSuccess>((event, emit) {
      emit(LoginSuccess(message: event.message));
    });

    on<OnLoginError>((event, emit) {
      emit(LoginFailure(message: event.message));
    });

    on<OnPasswordIncorrect>((event, emit) {
      emit(PasswordIncorrect(message: event.message));
    });

    on<OnUserNotRegistered>((event, emit) {
      emit(UserNotRegistered(message: event.message));
    });

    on<StoreLoginCredentials>((event, emit) async {
      try {
        // Store login credentials in shared preferences
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('mobileNumber', event.mobileNumber);
          prefs.setString('password', event.password);
        });
      } catch (e) {
        emit(LoginFailure(message: 'Failed to store login credentials'));
      }
    });

    on<AutoLogin>((event, emit) async {
      try {
        // Retrieve login credentials from shared preferences
        await SharedPreferences.getInstance().then((prefs) {
          String? mobileNumber = prefs.getString('mobileNumber');
          String? password = prefs.getString('password');

          if (mobileNumber != null && password != null) {
            // Auto login user
            add(LoginWithCredentials(
                mobileNumber: mobileNumber, password: password));
          } else {
            emit(LoginFailure(message: 'Failed to auto login'));
          }
        });
      } catch (e) {
        emit(LoginFailure(message: 'Failed to auto login'));
      }
    });

    on<Logout>((event, emit) async {
      emit(LoggingOut());
      try {
        // Clear login credentials from shared preferences
        await SharedPreferences.getInstance().then((prefs) {
          prefs.remove('mobileNumber');
          prefs.remove('password');
        });
        add(OnLogoutSuccess());
      } catch (e) {
        emit(LoginFailure(message: 'Failed to logout'));
      }
    });

    on<OnLogoutSuccess>((event, emit) {
      emit(LoggedOut());
    });
  }
}
