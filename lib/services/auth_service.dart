// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// AuthService is a class that provides methods to authenticate users.
///
/// It has methods to log in, register, save and retrieve tokens, and get user information.
/// It uses the http package to make API calls and the shared_preferences package to store tokens.
/// 
/// The class has a private apiUrl field that holds the base URL of the API.
/// 
/// The login method takes a username and password, sends a POST request to the API to authenticate the user,
/// and returns the user information if successful.
/// 
/// The register method takes a username, password, email, firstname, and lastname,
/// sends a POST request to the API to register the user, and returns the user information if successful.
/// 
/// The saveToken method takes a token and saves it to the shared preferences.
/// 
/// The getToken method retrieves the token from the shared preferences.
/// 
/// The decodeToken method takes a token, decodes it, and returns the payload.
/// 
/// The isTokenValid method takes a token, decodes it, and checks if it is valid.
/// 
/// The getId method retrieves the user ID from the shared preferences.
/// 
/// The saveId method takes a user ID and saves it to the shared preferences.
/// 
/// The logout method clears the token and user ID from the shared preferences.
/// 
/// The getUser method takes a token, decodes it, and returns the user information.
/// 
/// 
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

  Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = json.decode(
        utf8.decode(
          base64Url.decode(
            parts[1].padRight(parts[1].length + (4 - parts[1].length % 4) % 4, '='),
          ),
        ),
      );
      return payload;
    } catch (e) {
      return null;
    }
  }

  bool isTokenValid(String token) {
    final payload = decodeToken(token);
    if (payload == null || !payload.containsKey('exp')) {
      return false;
    }

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    return expiryDate.isAfter(DateTime.now());
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