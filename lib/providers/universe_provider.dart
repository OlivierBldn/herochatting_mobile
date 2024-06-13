// lib/providers/universe_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/universe.dart';
import '../services/auth_service.dart';

/// UniverseProvider is a class that provides universe-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has a private field _universes which is a list of Universe objects.
/// It provides a getter for the _universes field.
/// 
/// The class provides several methods for universe operations:
/// 
/// - fetchUniverses: This method fetches all the universes from the server.
///  It makes a GET request to the '/universes' endpoint.
/// If the response is successful, it updates the _universes field with the fetched universes and notifies listeners.
/// If the response is not successful, it throws an exception.
/// 
/// - updateUniverse: This method takes an id and a name, and updates the universe with the given id.
/// It makes a PUT request to the '/universes/$id' endpoint.
/// If the response is successful, it updates the corresponding universe in the _universes field and notifies listeners.
/// It returns a boolean indicating whether the update was successful.
/// 
/// - createUniverse: This method takes a name, and creates a new universe with the given name.
/// It makes a POST request to the '/universes' endpoint.
/// If the response is successful, it adds the new universe to the _universes field and notifies listeners.
/// It returns a boolean indicating whether the creation was successful.
/// 
/// 
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