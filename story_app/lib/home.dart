// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/services/auth_service.dart';
import 'models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    final AuthService authService = AuthService();
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.38.244:8080/posts/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _posts = List<Post>.from(data.map((post) => Post.fromJson(post)));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.ac_unit),
                SizedBox(width: 10),
                Expanded(child: Text("Story Share")),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150x150.png?text=User"),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchPosts,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _posts.isNotEmpty
                      ? ListView.separated(
                          itemCount: _posts.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (BuildContext context, int index) {
                            final post = _posts[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage((post
                                                    .userProfileImage !=
                                                null)
                                            ? "http://192.168.53.244:8080${post.userProfileImage}"
                                            : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.username,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            post.date.toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            backgroundColor: Colors.black,
                                            appBar: AppBar(
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            body: Center(
                                              child: Image.network(
                                                'http://192.168.53.244:8080${post.image}',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 400,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'http://192.168.53.244:8080${post.image}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(post.caption),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No posts found.'),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
