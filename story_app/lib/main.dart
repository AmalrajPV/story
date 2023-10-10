import 'package:flutter/material.dart';
import 'package:story_app/add_post_page.dart';
import 'package:story_app/main_page.dart';
import 'package:story_app/login_page.dart';
import 'package:story_app/register_page.dart';
import '../services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story App',
      theme: ThemeData(
        primaryColor: const Color(0xfff8a26c),
      ),
      home: FutureBuilder<bool>(
        future: Future.value(_authService.isLoggedIn()),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const MainPage();
            } else {
              return const LoginPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainPage(),
        '/post': (context) => const NewPostScreen(),
      },
    );
  }
}
