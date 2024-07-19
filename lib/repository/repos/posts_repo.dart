import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:progress_soft_app/repository/models/Post.dart';

class PostsRepository {
  List<Post> posts = [];
  List<Post> filteredPosts = [];

  Future<List<Post>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      posts = json.map((postJson) => Post.fromJson(postJson)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Post>> filterPosts(String query) async {
    try {
      filteredPosts = posts
          .where(
              (post) => post.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return filteredPosts;
    } catch (e) {
      return filteredPosts;
    }
  }
}
