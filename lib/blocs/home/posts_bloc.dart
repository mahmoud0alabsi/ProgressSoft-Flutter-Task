import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/repository/models/Post.dart';
import 'package:progress_soft_app/repository/repos/posts_repo.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsRepository postsRepository = PostsRepository();

  PostsBloc() : super(PostsInitial()) {
    on<FetchPosts>(
      (event, emit) {
        emit(PostsLoading());

        try {
          postsRepository.fetchPosts().then((posts) {
            add(OnFetchPostsSuccess(posts));
          });
        } catch (e) {
          add(OnFetchPostsFailed(e.toString()));
        }
      },
    );

    // Fetch posts on app start
    add(FetchPosts());

    on<OnFetchPostsFailed>(
      (event, emit) {
        emit(PostsFetchedFailed(event.message));
      },
    );

    on<OnFetchPostsSuccess>(
      (event, emit) {
        emit(PostsFetchedSuccess(event.posts, false));
      },
    );

    on<FilterPosts>(
      (event, emit) {
        emit(PostsLoading());
        try {
          if (event.query.isEmpty) {
            add(ClearFilter());
            return;
          }
          postsRepository.filterPosts(event.query).then((filteredPosts) {
            add(OnFilterPostsSuccess(filteredPosts));
          });
        } catch (e) {
          add(OnFilterPostsFailed(e.toString()));
        }
      },
    );

    on<OnFilterPostsFailed>(
      (event, emit) {
        emit(PostsFilteredFailed(event.message));
      },
    );

    on<OnFilterPostsSuccess>(
      (event, emit) {
        emit(PostsFetchedSuccess(event.posts, true));
      },
    );

    on<ClearFilter>(
      (event, emit) {
        emit(FilterCleared(postsRepository.posts, false));
      },
    );
  }
}
