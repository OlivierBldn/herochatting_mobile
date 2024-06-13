// lib/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

/// ChatDetailScreen is a StatefulWidget that displays the chat details.
/// 
/// It has a required parameter chatId which is the ID of the chat.
/// 
/// It has a List of Message objects messages to store the chat messages.
/// It has a boolean isLoading to indicate whether messages are being loaded.
/// It has a boolean isSendingMessage to indicate whether a message is being sent.
/// It has a boolean isRegenerating to indicate whether the last message is being regenerated.
/// It has a String characterName to store the name of the character.
/// 
/// The state has an initState method to initialize the state.
/// It loads the last message and character details when the screen is initialized.
/// 
/// The state has a _loadCharacterDetails method to load the character details.
/// It fetches the character details by chat ID and updates the characterName field.
/// 
/// The state has a _loadLastMessage method to load the last message.
/// It fetches the last message by chat ID and updates the messages field.
/// 
/// The state has a _loadAllMessages method to load all messages.
/// It fetches all messages by chat ID and updates the messages field.
/// 
/// The state has a _regenerateLastMessage method to regenerate the last message.
/// It regenerates the last message by chat ID and updates the messages field.
/// 
/// The state has a dispose method to dispose the controllers.
/// 
/// The state has a build method to build the UI.
/// It displays the chat messages in a ListView.
/// It displays a message input field to send messages.
/// It displays a button to regenerate the last message.
/// 
/// 
class ChatDetailScreen extends StatefulWidget {
  final int chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

/// ChatDetailScreenState is the state of the ChatDetailScreen.
/// 
/// 
class ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  List<Message> messages = [];
  bool isLoading = false;
  bool isSendingMessage = false;
  bool isRegenerating = false;
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
    setState(() {
      isRegenerating = true;
    });
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final success = await chatProvider.regenerateLastMessage(widget.chatId);
    if (!mounted) return;
    if (success) {
      final newMessage = await chatProvider.fetchLastMessage(widget.chatId);
      if (!mounted) return;
      if (newMessage != null) {
        setState(() {
          messages[messages.length - 1] = newMessage;
          isRegenerating = false;
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
      setState(() {
        isRegenerating = false;
      });
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
                    icon: SvgPicture.asset(
                      'assets/icons/send.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(AppColor.hBlue, BlendMode.srcIn),
                    ),
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
            if (isRegenerating)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
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