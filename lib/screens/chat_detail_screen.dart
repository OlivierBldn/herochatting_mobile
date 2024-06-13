// lib/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

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
  bool isSendingMessage = false;
  String? characterName;

  @override
  void initState() {
    super.initState();
    _loadLastMessage();
    _loadCharacterDetails();
  }

  Future<void> _loadCharacterDetails() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final character = await chatProvider.fetchCharacterByChatId(widget.chatId);
    if (mounted && character != null) {
      setState(() {
        characterName = character.name;
      });
    }
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(theme.iconTheme.color ?? AppColor.hGreyDark, BlendMode.srcIn),
                ),
              ),
            ),
            const Spacer(),
            Text(
              characterName ?? 'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        toolbarHeight: 80,
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
                  final isHuman = message.isSentByHuman;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isHuman) const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isHuman
                                  ? theme.colorScheme.background
                                  : theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                color: isHuman
                                    ? theme.textTheme.bodyLarge?.color
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                        if (!isHuman)
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 20,
                            child: SvgPicture.asset(
                              'assets/logo/logo.svg',
                              width: 40,
                              height: 40,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (isSendingMessage)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      setState(() {
                        isSendingMessage = true;
                      });
                      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                      final success = await chatProvider.sendMessage(widget.chatId, messageController.text);
                      setState(() {
                        isSendingMessage = false;
                      });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _regenerateLastMessage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: isDarkMode ? Colors.black : Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Regenerate Last Message',
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}