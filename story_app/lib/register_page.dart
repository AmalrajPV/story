import 'package:flutter/material.dart';
import 'package:story_app/login_page.dart';
import 'package:story_app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String _username = '';
  String _email = '';
  String _password = '';
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void editRequest(String key, String value){
    
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60.0),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                ),
                              )
                            : const Icon(Icons.person, size: 70),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: myAlert,
                          child: const CircleAvatar(
                            radius: 22,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        bool result = await _authService.register(
                          username: _username,
                          email: _email,
                          password: _password,
                          image: image != null ? XFile(image!.path) : null,
                        );
                        if (result) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Registration failed')),
                          );
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Already have an account? Login.'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
