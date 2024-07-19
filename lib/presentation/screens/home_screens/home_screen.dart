import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/blocs/home/posts_bloc.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';
import 'package:progress_soft_app/repository/models/Post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      BlocProvider.of<PostsBloc>(context)
          .add(FilterPosts(_searchController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Post> filteredPosts = [];
    bool isFiltered = false;
    return Scaffold(
      body: BlocBuilder<PostsBloc, PostsState>(
        bloc: BlocProvider.of<PostsBloc>(context),
        builder: (context, state) {
          if (state is PostsLoading) {
            return const LoadingSpinnerPage();
          } else if (state is PostsFetchedFailed) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is PostsFilteredFailed) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is PostsFetchedSuccess) {
            filteredPosts = state.posts;
            isFiltered = state.isFiltered;
          } else if (state is PostsFilteredSuccess) {
            filteredPosts = state.posts;
            isFiltered = state.isFiltered;
          } else if (state is FilterCleared) {
            filteredPosts = state.posts;
            isFiltered = state.isFiltered;
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.blue, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                if(isFiltered)
                Text(
                  filteredPosts.isEmpty
                      ? 'No posts found'
                      : 'Posts found: ${filteredPosts.length}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            filteredPosts[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            filteredPosts[index].body,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
