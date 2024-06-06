// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final String apiUrl = 'https://mds.sprw.dev';

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
        final tokenParts = jsonResponse['token'].split('.');
        final payload = json.decode(
          utf8.decode(
            base64Url.decode(
              tokenParts[1].padRight(
                tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
                '=',
              ),
            ),
          ),
        );
        final data = jsonDecode(payload['data']);
        return User.fromJson(data);
      }
    }
    return null;
  }

  Future<User?> register(String username, String password, String email, String firstname, String lastname) async {
    final response = await http.post(
      Uri.parse('$apiUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('token');
  }

  Future<User?> getUser(String token) async {
    final tokenParts = token.split('.');
    final payload = json.decode(
      utf8.decode(
        base64Url.decode(
          tokenParts[1].padRight(
            tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
            '=',
          ),
        ),
      ),
    );
    final data = jsonDecode(payload['data']);
    return User.fromJson(data);
  }
}