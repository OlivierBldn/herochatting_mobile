// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/auth_service.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];

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
}