// lib/screens/chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends StatelessWidget {
  final int characterId;

  const ChatListScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: FutureBuilder(
        future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<ChatProvider>(
              builder: (ctx, chatProvider, child) {
                final chats = chatProvider.chats.where((chat) => chat.characterId == characterId).toList();
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (ctx, i) {
                    final chat = chats[i];
                    return ListTile(
                      title: Text('Chat ID: ${chat.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final success = await chatProvider.deleteChat(chat.id);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chat deleted')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to delete chat')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/chat_detail', arguments: chat.id);
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}