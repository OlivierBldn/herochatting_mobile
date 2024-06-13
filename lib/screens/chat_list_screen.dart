import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/character.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

/// ChatListScreen is a StatelessWidget that displays a list of chats.
/// It uses the ChatProvider to fetch the chats and the CharacterProvider to fetch the character details.
/// 
/// The screen displays a list of chats with the character's name and image.
/// Each chat item has a delete button that allows the user to delete the chat.
/// 
/// The screen also has a toggle button to switch between light and dark themes.
/// 
/// 
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

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
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                      theme.iconTheme.color ?? AppColor.hGreyDark,
                      BlendMode.srcIn),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Chats',
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                fontWeight: FontWeight.w500,
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
      body: FutureBuilder(
        future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ChatProvider>(
              builder: (ctx, chatProvider, child) {
                final chats = chatProvider.chats;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (ctx, i) {
                    final chat = chats[i];
                    return FutureBuilder<Character?>(
                      future: chatProvider.fetchCharacterDetails(chat.characterId),
                      builder: (ctx, charSnapshot) {
                        if (charSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Loading...'),
                          );
                        } else if (charSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${charSnapshot.error}'),
                          );
                        } else {
                          final character = charSnapshot.data;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/chat_detail', arguments: chat.id);
                              },
                              splashColor: AppColor.hBlueLight,
                              highlightColor: AppColor.hBlueLight,
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: character != null && character.image.isNotEmpty
                                          ? ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            )
                                          : ClipOval(
                                              child: Container(
                                                width: 75,
                                                height: 75,
                                                color: Colors.grey.shade300,
                                                child: Icon(Icons.person, color: Colors.grey.shade800),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          character?.name ?? 'Unknown Character',
                                          style: TextStyle(
                                            color: theme.textTheme.bodyLarge?.color ?? AppColor.hGreyDark,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/cross.svg',
                                        width: 32,
                                        height: 32,
                                        colorFilter: ColorFilter.mode(
                                            theme.iconTheme.color ?? AppColor.hGreyDark,
                                            BlendMode.srcIn),
                                      ),
                                      onPressed: () async {
                                        final success = await chatProvider.deleteChat(chat.id);
                                        if (!context.mounted) return;
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
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