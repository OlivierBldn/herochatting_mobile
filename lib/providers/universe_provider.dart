// lib/providers/universe_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/universe.dart';
import '../services/auth_service.dart';

class UniverseProvider with ChangeNotifier {
  List<Universe> _universes = [];

  List<Universe> get universes => _universes;

  Future<void> fetchUniverses() async {
    final token = await AuthService().getToken();
    final response = await http.get(Uri.parse('${AuthService().apiUrl}/universes'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> universeJson = json.decode(response.body);
      _universes = universeJson.map((json) => Universe.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load universes');
    }
  }

  Future<bool> updateUniverse(int id, String name) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${AuthService().apiUrl}/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final updatedUniverse = Universe.fromJson(json.decode(response.body));
      final index = _universes.indexWhere((universe) => universe.id == id);
      if (index != -1) {
        _universes[index] = updatedUniverse;
        notifyListeners();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUniverse(String name) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse('${AuthService().apiUrl}/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      final newUniverse = Universe.fromJson(json.decode(response.body));
      _universes.add(newUniverse);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}