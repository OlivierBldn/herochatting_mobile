// lib/providers/character_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character.dart';
import '../services/auth_service.dart';

class CharacterProvider with ChangeNotifier {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  Future<void> fetchCharacters(int universeId) async {
    final token = await AuthService().getToken();
    final response = await http.get(Uri.parse('${AuthService().apiUrl}/universes/$universeId/characters'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> characterJson = json.decode(response.body);
      _characters = characterJson.map((json) => Character.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<bool> createCharacter(int universeId, String name) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse('${AuthService().apiUrl}/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      final newCharacter = Character.fromJson(json.decode(response.body));
      _characters.add(newCharacter);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCharacter(int universeId, int characterId, String name) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${AuthService().apiUrl}/universes/$universeId/characters/$characterId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final updatedCharacter = Character.fromJson(json.decode(response.body));
      final index = _characters.indexWhere((character) => character.id == characterId);
      if (index != -1) {
        _characters[index] = updatedCharacter;
        notifyListeners();
      }
      return true;
    } else {
      return false;
    }
  }
}