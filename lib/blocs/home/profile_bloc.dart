import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/repository/models/CustomUser.dart';
import 'package:progress_soft_app/repository/repos/users_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  CustomUser user = CustomUser.emptyObject();

  ProfileBloc() : super(ProfileInitial()) {
    on<GetUserData>((event, emit) async {
      emit(ProfileLoading());
      try {
        user = await UsersRepository.getCurrentUser();
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
