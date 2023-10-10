// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:story_app/services/auth_service.dart';

class Post {
  final String caption;
  final XFile? image;
  final List<dynamic> receiverIds;

  Post({required this.caption, this.image, required this.receiverIds});

  Future<bool> submit() async {
    AuthService authService = AuthService();
    final token = await authService.getToken();
    final url = Uri.parse('http://192.168.53.244:8000/posts');
    final request = http.MultipartRequest('POST', url);
    request.fields['caption'] = caption;

    for (int i = 0; i < receiverIds.length; i++) {
      request.fields['recipients[$i]'] = receiverIds[i];
    }

    if (image != null) {
      final file = await http.MultipartFile.fromPath('image', image!.path);
      request.files.add(file);
    }
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    });

    final response = await request.send();
    return response.statusCode == 200;
  }
}

class User {
  String id;
  String username;
  String email;
  String? image;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      image: json['image'],
    );
  }
}

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  XFile? _image;
  List<User> _users = [];
  List<User> _usersSearch = [];
  final List<String> _receiverIds = [];
  final TextEditingController _searchController = TextEditingController();

  void _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _getUsers() async {
    final AuthService authService = AuthService();
    final token = await authService.getToken();
    final response = await http.get(
        Uri.parse('http://192.168.53.244:8000/users'),
        headers: {'Authorization': 'Bearer $token'});
    final List<dynamic> responseData = jsonDecode(response.body);
    setState(() {
      _users = responseData.map((e) => User.fromJson(e)).toList();
      _usersSearch = responseData.map((e) => User.fromJson(e)).toList();
    });
  }

  Future<void> _submitPost() async {
    if (_image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
      return;
    }
    final post = Post(
        caption: _captionController.text,
        image: _image,
        receiverIds: _receiverIds);
    final success = await post.submit();
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post submitted')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to submit post')));
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitPost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: null,
                controller: _captionController,
                decoration: const InputDecoration(
                  labelText: 'Caption',
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? const Center(
                          child: Text(
                            'Tap to select an image',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Recipients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (query) {
                  setState(() {
                    _usersSearch = _filterUsers(query);
                  });
                },
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _usersSearch.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage((_usersSearch[index]
                                  .image !=
                              null)
                          ? "http://192.168.53.244:8000${_usersSearch[index].image!}"
                          : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
                    ),
                    trailing: Checkbox(
                      value: _receiverIds.contains(_usersSearch[index].id),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked!) {
                            _receiverIds.add(_usersSearch[index].id);
                          } else {
                            _receiverIds.remove(_usersSearch[index].id);
                          }
                        });
                      },
                    ),
                    title: Text(_usersSearch[index].username),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<User> _filterUsers(String query) {
    return _users.where((user) {
      final username = user.username.toLowerCase();
      final searchText = query.toLowerCase();
      return username.contains(searchText);
    }).toList();
  }
}
