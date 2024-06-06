// lib/models/chat.dart

import 'message.dart';

class Chat {
  final int id;
  final int characterId;
  List<Message> messages;

  Chat({
    required this.id,
    required this.characterId,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: int.parse(json['id'].toString()),
      characterId: int.parse(json['character_id'].toString()),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((message) => Message.fromJson(message))
              .toList() ??
          [],
    );
  }
}