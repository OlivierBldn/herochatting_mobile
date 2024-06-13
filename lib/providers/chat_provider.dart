// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/character.dart';
import '../services/auth_service.dart';

/// ChatProvider is a class that provides chat-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has a private field _chats which is a list of Chat objects.
/// 
/// It also has a private field _characterCache which is a map of characterId to Character objects.
/// This is used to cache character details to avoid fetching them multiple times.
/// 
/// It provides a getter for the _chats field.
/// 
/// The class provides several methods for chat operations:
/// 
/// - fetchChats: This method fetches the chats for the current user.
///  It makes a GET request to the '/conversations' endpoint with the user_id parameter.
/// If the response is successful, it updates the _chats field with the fetched chats and notifies listeners.
/// If the response is not successful, it throws an exception.
/// 
/// - fetchLastMessage: This method takes a chatId and fetches the last message in the chat.
/// It makes a GET request to the '/conversations/$chatId/messages' endpoint.
/// If the response is successful and there are messages, it returns the last message.
/// If the response is successful and there are no messages, it returns null.
/// If the response is not successful, it throws an exception.
/// 
/// - fetchMessages: This method takes a chatId and an optional beforeMessageId, and fetches the messages for the chat.
/// It makes a GET request to the '/conversations/$chatId/messages' endpoint with the before_id parameter.
/// If the response is successful, it returns a list of messages.
/// If the response is not successful, it throws an exception.
/// 
/// - createChat: This method takes a characterId and creates a new chat with the character.
/// It makes a POST request to the '/conversations' endpoint.
/// If the response is successful, it adds the new chat to the _chats field and notifies listeners.
/// It returns a boolean indicating whether the creation was successful.
/// 
/// - deleteChat: This method takes a chatId and deletes the chat.
/// It makes a DELETE request to the '/conversations/$chatId' endpoint.
/// If the response is successful, it removes the chat from the _chats field and notifies listeners.
/// It returns a boolean indicating whether the deletion was successful.
/// 
/// - sendMessage: This method takes a chatId and a content, and sends a message in the chat.
/// It makes a POST request to the '/conversations/$chatId/messages' endpoint.
/// If the response is successful, it adds the new message to the chat and notifies listeners.
/// It returns a boolean indicating whether the sending was successful.
/// 
/// - reloadChat: This method takes a chatId and reloads the chat.
/// It makes a GET request to the '/conversations/$chatId' endpoint.
/// If the response is successful, it updates the chat in the _chats field and notifies listeners.
/// It returns a boolean indicating whether the reload was successful.
/// 
/// - regenerateLastMessage: This method takes a chatId and regenerates the last message in the chat.
/// It makes a PUT request to the '/conversations/$chatId' endpoint.
/// If the response is successful, it reloads the chat and returns a boolean indicating whether the regeneration was successful.
/// If the response is not successful, it returns false.
/// 
/// - fetchCharacterDetails: This method takes a characterId and fetches the character details.
/// It makes a GET request to the '/characters/$characterId' endpoint.
/// If the response is successful, it returns the character details.
/// If the response is not successful, it throws an exception.
/// 
/// - fetchCharacterByChatId: This method takes a chatId and fetches the character details for the chat.
/// It makes a GET request to the '/conversations/$chatId' endpoint.
/// If the response is successful, it returns the character details.
/// If the response is not successful, it throws an exception.
/// 
/// 
class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  final Map<int, Character> _characterCache = {};

  List<Chat> get chats => _chats;

  Future<void> fetchChats() async {
    final token = await AuthService().getToken();
    final userId = await AuthService().getId();
    try {
      final response = await http.get(Uri.parse('${AuthService().apiUrl}/conversations?user_id=$userId'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> chatJson = json.decode(response.body) as List<dynamic>;
        _chats = chatJson.map((json) => Chat.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Message?> fetchLastMessage(int chatId) async {
    final token = await AuthService().getToken();
    try {
      final response = await http.get(Uri.parse('${AuthService().apiUrl}/conversations/$chatId/messages'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = json.decode(response.body) as List<dynamic>;
        if (messagesJson.isNotEmpty) {
          final lastMessageJson = messagesJson.last;
          return Message.fromJson(lastMessageJson);
        }
        return null;
      } else {
        throw Exception('Failed to load last message');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Message>> fetchMessages(int chatId, {int? beforeMessageId}) async {
    final token = await AuthService().getToken();
    try {
      final url = Uri.parse('${AuthService().apiUrl}/conversations/$chatId/messages${beforeMessageId != null ? '?before_id=$beforeMessageId' : ''}');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = json.decode(response.body) as List<dynamic>;
        return messagesJson.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> createChat(int characterId) async {
    final token = await AuthService().getToken();
    final userId = await AuthService().getId();
    try {
      final response = await http.post(
        Uri.parse('${AuthService().apiUrl}/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'character_id': characterId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201) {
        final newChat = Chat.fromJson(json.decode(response.body));
        _chats.add(newChat);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteChat(int chatId) async {
    final token = await AuthService().getToken();
    try {
      final response = await http.delete(
        Uri.parse('${AuthService().apiUrl}/conversations/$chatId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _chats.removeWhere((chat) => chat.id == chatId);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> sendMessage(int chatId, String content) async {
    final token = await AuthService().getToken();
    try {
      final response = await http.post(
        Uri.parse('${AuthService().apiUrl}/conversations/$chatId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final newMessage = Message.fromJson(responseBody['message']);
        final newAnswer = Message.fromJson(responseBody['answer']);
        
        final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
        if (chatIndex != -1) {
          _chats[chatIndex].messages.add(newMessage);
          _chats[chatIndex].messages.add(newAnswer);
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> reloadChat(int chatId) async {
    final token = await AuthService().getToken();

    try {
      final response = await http.get(
        Uri.parse('${AuthService().apiUrl}/conversations/$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final updatedChat = Chat.fromJson(responseBody);

        final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
        if (chatIndex != -1) {
          _chats[chatIndex] = updatedChat;
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> regenerateLastMessage(int chatId) async {
    final token = await AuthService().getToken();
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) {
      return false;
    }

    try {
      final response = await http.put(
        Uri.parse('${AuthService().apiUrl}/conversations/$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(milliseconds: 500));

        try {
          final response = await http.put(
            Uri.parse('${AuthService().apiUrl}/conversations/$chatId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            return await reloadChat(chatId);
          } else {
            return false;
          }
        } catch (error) {
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<Character?> fetchCharacterDetails(int characterId) async {
    if (_characterCache.containsKey(characterId)) {
      return _characterCache[characterId];
    }

    final token = await AuthService().getToken();
    try {
      final response = await http.get(
        Uri.parse('${AuthService().apiUrl}/characters/$characterId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final characterJson = json.decode(response.body);
        final character = Character.fromJson(characterJson);
        _characterCache[characterId] = character;
        return character;
      } else {
        throw Exception('Failed to load character details');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Character?> fetchCharacterByChatId(int chatId) async {
    final token = await AuthService().getToken();
    try {
      final response = await http.get(
        Uri.parse('${AuthService().apiUrl}/conversations/$chatId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final conversationJson = json.decode(response.body);
        final characterId = conversationJson['character_id'];
        return await fetchCharacterDetails(characterId);
      } else {
        throw Exception('Failed to load conversation details');
      }
    } catch (error) {
      rethrow;
    }
  }
}