import 'package:flutter/material.dart';
import 'package:story_app/my_post_page.dart';
import './settings_page.dart';
import './profile_page.dart';
import './home.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomePage(),
    const ProfilePage(),
    const MyPostPage(),
    const SettingsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/post');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 5,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: _currentIndex == 0
                              ? Colors.deepPurpleAccent
                              : Colors.blueGrey,
                        ),
                        // Text("Home"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: _currentIndex == 1
                              ? Colors.deepPurpleAccent
                              : Colors.blueGrey,
                        ),
                        // Text("Home"),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article,
                          color: _currentIndex == 2
                              ? Colors.deepPurpleAccent
                              : Colors.blueGrey,
                        ),
                        // Text("Home"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: _currentIndex == 3
                              ? Colors.deepPurpleAccent
                              : Colors.blueGrey,
                        ),
                        // Text("Home"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
