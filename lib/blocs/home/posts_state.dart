part of 'posts_bloc.dart';

abstract class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsFetchedSuccess extends PostsState {
  final List<Post> posts;
  final bool isFiltered;

  PostsFetchedSuccess(this.posts, this.isFiltered);
}

class PostsFetchedFailed extends PostsState {
  final String message;

  PostsFetchedFailed(this.message);
}

final class PostsFilteredSuccess extends PostsState {
  final List<Post> posts;
  final bool isFiltered;

  PostsFilteredSuccess(this.posts, this.isFiltered);
}

final class PostsFilteredFailed extends PostsState {
  final String message;

  PostsFilteredFailed(this.message);
}

final class FilterCleared extends PostsState {
  final List<Post> posts;
  final bool isFiltered;

  FilterCleared(this.posts, this.isFiltered);
}