// lib/screens/character_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  CharacterDetailScreenState createState() => CharacterDetailScreenState();
}

class CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late Character character;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    character = widget.character;
  }

  Future<void> _regenerateDescription() async {
    setState(() {
      isLoading = true;
    });
    final characterProvider = Provider.of<CharacterProvider>(context, listen: false);
    final success = await characterProvider.regenerateCharacterDescription(character.universeId, character.id);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (success) {
      setState(() {
        character = characterProvider.characters.firstWhere((c) => c.id == character.id);
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Description regenerated')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to regenerate description')),
        );
      }
    }
  }

  Future<void> _createChat() async {
    setState(() {
      isLoading = true;
    });
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final success = await chatProvider.createChat(character.id);
    setState(() {
      isLoading = false;
    });
    if (!context.mounted) return;
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat created')),
        );
      }
      if(!mounted) return;
      Navigator.of(context).pushNamed('/chat_list', arguments: character.id);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create chat')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor ?? AppColor.hWhite,
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
              character.name,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (character.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Column(
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 50),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    character.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    character.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _regenerateDescription,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isDarkMode ? AppColor.hBlack : theme.colorScheme.onSecondary,
                      backgroundColor: isDarkMode ? AppColor.hWhite : theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: isDarkMode ? AppColor.hBlack : AppColor.hBlack),
                        const SizedBox(width: 10),
                        Text(
                          'Regenerate Description',
                          style: TextStyle(
                            color: isDarkMode ? AppColor.hBlack : AppColor.hBlack,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _createChat,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isDarkMode ? AppColor.hBlack : theme.colorScheme.onSecondary,
                      backgroundColor: isDarkMode ? AppColor.hWhite : theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, color: isDarkMode ? AppColor.hBlack : AppColor.hBlack),
                        const SizedBox(width: 10),
                        Text(
                          'Create Chat',
                          style: TextStyle(
                            color: isDarkMode ? AppColor.hBlack : AppColor.hBlack,
                            fontSize: 16,
                          ),
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