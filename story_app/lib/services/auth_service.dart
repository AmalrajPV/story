import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AuthService {
  static const _baseUrl = 'http://192.168.38.244:8000/auth';
  final _storage = const FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email.trim(),
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['access_token'];
      await _storage.write(key: 'token', value: token);
      return token;
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    return token;
  }

  Future<bool> isLoggedIn() async {
    // ignore: unnecessary_null_comparison
    return await _storage.read(key: 'token') != null;
  }

  Future<bool> register(
      {required String username,
      required String email,
      required String password,
      XFile? image}) async {
    final url = Uri.parse('$_baseUrl/register');
    final request = http.MultipartRequest('POST', url);
    request.fields['username'] = username.trim();
    request.fields['email'] = email.trim();
    request.fields['password'] = password;
    if (image != null) {
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
