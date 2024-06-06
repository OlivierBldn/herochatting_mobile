// lib/models/message.dart

class Message {
  final int id;
  final String content;
  final bool isSentByHuman;

  Message({
    required this.id,
    required this.content,
    required this.isSentByHuman,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: int.parse(json['id'].toString()),
      content: json['content'] ?? '',
      isSentByHuman: json['is_sent_by_human'] is bool ? json['is_sent_by_human'] : (json['is_sent_by_human'].toString().toLowerCase() == 'true'),
    );
  }
}