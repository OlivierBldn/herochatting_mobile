// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';


/// AuthProvider is a class that provides authentication-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has two private fields: _user and _token, which hold the current user and token respectively.
/// It also has a private instance of AuthService, which is used to perform the actual authentication operations.
/// 
/// The class provides getters for the user and token fields, and several methods for authentication operations:
/// 
/// - login: This method takes a username and password, and uses the AuthService to authenticate the user.
///   If the user is authenticated successfully, it updates the _user and _token fields and notifies listeners.
///   If the user is not authenticated, it throws an exception.
/// 
/// - register: This method takes a username, password, email, firstname, and lastname, and uses the AuthService to register the user.
///   It updates the _user field and notifies listeners. It returns a boolean indicating whether the registration was successful.
/// 
/// - logout: This method uses the AuthService to log out the user. It then clears the _user and _token fields and notifies listeners.
/// 
/// - tryAutoLogin: This method attempts to automatically log in the user. It gets the token from the AuthService,
///   and if the token is valid, it gets the user associated with the token and updates the _user and _token fields.
///   If the token is not valid, it clears the _user and _token fields. In both cases, it notifies listeners.
class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    _user = await _authService.login(username, password);
    if (_user != null) {
      _token = await _authService.getToken();
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> register(String username, String password, String email, String firstname, String lastname) async {
    _user = await _authService.register(username, password, email, firstname, lastname);
    notifyListeners();
    return _user != null;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final token = await _authService.getToken();
    if (token != null && _authService.isTokenValid(token)) {
      _user = await _authService.getUser(token);
      _token = token;
      notifyListeners();
    } else {
      _user = null;
      _token = null;
    }
  }
}