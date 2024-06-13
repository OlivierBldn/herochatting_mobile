// lib/providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../services/auth_service.dart';

/// UserProvider is a class that provides user-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has a private field _users which is a list of User objects.
/// It provides a getter for the _users field.
/// 
/// The class provides several methods for user operations:
/// 
/// - fetchUsers: This method fetches all the users from the server.
/// It makes a GET request to the '/users' endpoint.
/// If the response is successful, it updates the _users field with the fetched users and notifies listeners.
/// If the response is not successful, it throws an exception.
/// 
/// - filterUsers: This method takes a query string and filters the users based on the query.
/// It updates the _filteredUsers field with the filtered users and notifies listeners.
/// 
/// - updateUser: This method takes an id, username, email, firstname, and lastname, and updates the user with the given id.
/// It makes a PUT request to the '/users/$id' endpoint.
/// If the response is successful, it updates the corresponding user in the _users field and notifies listeners.
/// It returns a boolean indicating whether the update was successful.
/// 
/// 
class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];

  List<User> get users => _filteredUsers;
  List<User> get filteredUsers => _filteredUsers.isEmpty ? _users : _filteredUsers;


  Future<void> fetchUsers() async {
    final token = await AuthService().getToken();
    final response = await http.get(Uri.parse('${AuthService().apiUrl}/users'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      _users = userJson.map((json) => User.fromJson(json)).toList();
      _filteredUsers = _users;
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) {
        final usernameLower = user.username.toLowerCase();
        final emailLower = user.email.toLowerCase();
        final queryLower = query.toLowerCase();

        return usernameLower.contains(queryLower) || emailLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
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