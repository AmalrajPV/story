import 'package:flutter/material.dart';
import 'package:story_app/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            _authService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text("Logout")),
    );
  }
}
