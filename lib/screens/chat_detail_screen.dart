// lib/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';

class ChatDetailScreen extends StatefulWidget {
  final int chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _loadLastMessage();
  }

  Future<void> _loadLastMessage() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final lastMessage = await chatProvider.fetchLastMessage(widget.chatId);
    if (lastMessage != null) {
      setState(() {
        messages.add(lastMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.chatId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final message = messages[i];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.isSentByHuman ? 'You' : 'Character'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(labelText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                    final success = await chatProvider.sendMessage(widget.chatId, messageController.text);
                    if (success) {
                      final newMessage = Message(
                        id: DateTime.now().millisecondsSinceEpoch,
                        content: messageController.text,
                        isSentByHuman: true,
                      );
                      final responseMessage = await chatProvider.fetchLastMessage(widget.chatId);
                      if (responseMessage != null) {
                        setState(() {
                          messages.add(newMessage);
                          messages.add(responseMessage);
                        });
                      }
                      messageController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message sent')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to send message')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}