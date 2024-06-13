// // lib/providers/character_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character.dart';
import '../services/auth_service.dart';

/// CharacterProvider is a class that provides character-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has a private field _characters which is a list of Character objects.
/// It provides a getter for the _characters field.
/// 
/// The class provides several methods for character operations:
/// 
/// - fetchCharacters: This method takes a universeId and fetches the characters for that universe.
///   It makes a GET request to the '/universes/$universeId/characters' endpoint.
///   If the response is successful, it updates the _characters field with the fetched characters and notifies listeners.
///   If the response is not successful, it throws an exception.
/// 
/// - createCharacter: This method takes a universeId and a name, and creates a new character in that universe with the given name.
///   It makes a POST request to the '/universes/$universeId/characters' endpoint.
///   If the response is successful, it adds the new character to the _characters field and notifies listeners.
///   It returns a boolean indicating whether the creation was successful.
/// 
/// - updateCharacter: This method takes a universeId, a characterId, and a name, and updates the character with the given characterId in the given universe.
///   It makes a PUT request to the '/universes/$universeId/characters/$characterId' endpoint.
///   If the response is successful, it updates the corresponding character in the _characters field and notifies listeners.
///   It returns a boolean indicating whether the update was successful.
/// 
/// - regenerateCharacterDescription: This method takes a universeId and a characterId, and regenerates the description of the character with the given characterId in the given universe.
///   It makes a PUT request to the '/universes/$universeId/characters/$characterId' endpoint.
///   If the response is successful, it updates the corresponding character in the _characters field and notifies listeners.
///   It returns a boolean indicating whether the regeneration was successful.
/// 
/// 
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

  Future<bool> regenerateCharacterDescription(int universeId, int characterId) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${AuthService().apiUrl}/universes/$universeId/characters/$characterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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