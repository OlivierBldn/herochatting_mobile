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
  final ScrollController scrollController = ScrollController();
  
  List<Message> messages = [];
  bool isLoading = false;
  bool hasMoreMessages = true;

  @override
  void initState() {
    super.initState();
    _loadLastMessage();
  }

  Future<void> _loadLastMessage() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final lastMessage = await chatProvider.fetchLastMessage(widget.chatId);
    if (mounted && lastMessage != null) {
      setState(() {
        messages = [lastMessage];
      });
    }
  }

  Future<void> _loadAllMessages() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final allMessages = await chatProvider.fetchMessages(widget.chatId);

    if (mounted) {
      setState(() {
        isLoading = false;
        messages = allMessages;
      });
    }
  }

  Future<void> _regenerateLastMessage() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final success = await chatProvider.regenerateLastMessage(widget.chatId);
    if (!mounted) return;
    if (success) {
      final newMessage = await chatProvider.fetchLastMessage(widget.chatId);
      if (!mounted) return;
      if (newMessage != null) {
        setState(() {
          messages[messages.length - 1] = newMessage;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Last message regenerated')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to regenerate last message')),
        );
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.chatId}'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllMessages,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  final message = messages[i];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.isSentByHuman ? 'You' : 'Character'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _regenerateLastMessage,
              child: const Text('Regenerate Last Message'),
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
                      if (!mounted) return;
                      if (success) {
                        final newMessage = Message(
                          id: DateTime.now().millisecondsSinceEpoch,
                          content: messageController.text,
                          isSentByHuman: true,
                        );
                        final responseMessage = await chatProvider.fetchLastMessage(widget.chatId);
                        if (!context.mounted) return;
                        if (responseMessage != null) {
                          setState(() {
                            messages.add(newMessage);
                            messages.add(responseMessage);
                          });

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        }
                        messageController.clear();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message sent')),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to send message')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}