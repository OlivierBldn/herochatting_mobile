// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

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