import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_app/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  String? editUsername;

  Future<User> fetchUser() async {
    final AuthService authService = AuthService();
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.53.244:8000/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser().then((user) {
      setState(() {
        currentUser = user;
        editUsername = currentUser?.username ?? "";
      });
    });
  }

  void editRequest(String key, String value) async {
    http.MultipartRequest('PUT',
        Uri.parse("http://192.168.53.244:8080/users/${currentUser?.email}"));
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Edit username'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  TextField(
                    onChanged: (query) {
                      editUsername = query;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const TextButton(onPressed: null, child: Text("Save"))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          backgroundColor: Colors.black,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                          ),
                          body: Center(
                            child: currentUser?.image != null
                                ? Image.network(
                                    'http://192.168.53.244:8080${currentUser?.image}',
                                    fit: BoxFit.contain,
                                  )
                                : const Center(
                                    child: Text(
                                      "No Image",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                      currentUser?.image != null
                          ? 'http://192.168.53.244:8080${currentUser?.image}'
                          : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  currentUser?.username ?? "",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  currentUser?.email ?? "",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person,
                          color: Colors.deepPurpleAccent),
                      title: const Text('Username'),
                      subtitle: Text(currentUser?.username ?? ""),
                      trailing: IconButton(
                          onPressed: () {
                            myAlert();
                          },
                          icon: const Icon(Icons.edit)),
                      onTap: () {},
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.deepPurpleAccent,
                      ),
                      title: const Text('Email'),
                      subtitle: Text(currentUser?.email ?? ""),
                      onTap: () {},
                    ),
                    const SizedBox(height: 16.0),
                    const ListTile(
                      leading: Icon(Icons.lock, color: Colors.deepPurpleAccent),
                      title: Text('Password'),
                      subtitle: Text('********'),
                      // trailing: IconButton(
                      //     onPressed: () {}, icon: const Icon(Icons.edit)),
                      // onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  String? image;
  final String username;
  final String email;
  User({required this.email, required this.username, this.image});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        image: json['image'], email: json['email'], username: json['username']);
  }
}
