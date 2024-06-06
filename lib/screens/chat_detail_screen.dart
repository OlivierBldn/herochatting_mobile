// lib/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat.dart';

class ChatDetailScreen extends StatelessWidget {
  final int chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat $chatId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Consumer<ChatProvider>(
                    builder: (ctx, chatProvider, child) {
                      final chat = chatProvider.chats.firstWhere((chat) => chat.id == chatId, orElse: () => Chat(id: chatId, characterId: 0, messages: []));
                      final messages = chat.messages;

                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (ctx, i) {
                          final message = messages[i];
                          return ListTile(
                            title: Text(message.content),
                            subtitle: Text(message.isSentByHuman ? 'You' : 'Character'),
                          );
                        },
                      );
                    },
                  );
                }
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
                    try {
                      final success = await chatProvider.sendMessage(chatId, messageController.text);
                      if (success) {
                        messageController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message sent')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to send message')),
                        );
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
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