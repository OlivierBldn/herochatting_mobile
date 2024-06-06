import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final token = await AuthService().getToken();
    final response = await http.get(Uri.parse('${AuthService().apiUrl}/users'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      _users = userJson.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<bool> updateUser(int id, String username, String email, String firstname, String lastname) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${AuthService().apiUrl}/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
      }),
    );

    if (response.statusCode == 200) {
      final updatedUser = User.fromJson(json.decode(response.body));
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
      return true;
    } else {
      return false;
    }
  }
}