part of 'profile_bloc.dart';

abstract class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final CustomUser user;

  ProfileLoaded(this.user);
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
