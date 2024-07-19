part of 'posts_bloc.dart';

abstract class PostsEvent {}

class FetchPosts extends PostsEvent {}

class OnFetchPostsSuccess extends PostsEvent {
  final List<Post> posts;

  OnFetchPostsSuccess(this.posts);
}

class OnFetchPostsFailed extends PostsEvent {
  final String message;

  OnFetchPostsFailed(this.message);
}

class FilterPosts extends PostsEvent {
  final String query;

  FilterPosts(this.query);
}

class OnFilterPostsSuccess extends PostsEvent {
  final List<Post> posts;

  OnFilterPostsSuccess(this.posts);
}

class OnFilterPostsFailed extends PostsEvent {
  final String message;

  OnFilterPostsFailed(this.message);
}

class ClearFilter extends PostsEvent {}
