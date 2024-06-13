// lib/screens/character_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/character_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

/// CharacterListScreen is a StatelessWidget that displays a list of characters for a given universe.
/// It takes a universeId as a parameter and fetches the characters for that universe.
/// It provides a text field to create a new character in the universe.
/// It displays the characters in a grid view with their name and image.
/// It allows the user to tap on a character to view the character details.
/// It also provides a button to toggle the theme of the app.
/// 
/// The class uses the Provider package to access the CharacterProvider and ThemeProvider.
/// It uses the Consumer widget to listen for changes in the CharacterProvider and ThemeProvider.
/// 
/// The class uses the FutureBuilder widget to fetch the characters for the universe.
/// It displays a loading indicator while the characters are being fetched.
/// 
/// The class uses a TextEditingController to get the name of the new character.
/// It provides a method createCharacter to create a new character in the universe.
/// It shows a loading dialog while the character is being created.
/// It shows a snackbar with a success or error message after the character is created.
/// 
/// The class uses a GridView.builder to display the characters in a grid view.
/// It displays the character image and name in a card.
/// It allows the user to tap on a character to view the character details.
/// 
/// The class uses the Navigator to navigate to the character detail screen when a character is tapped.
/// 
/// The class provides a button to toggle the theme of the app.
/// It uses the ThemeProvider to toggle the theme when the button is pressed.
/// 
/// The class uses the ScaffoldMessenger to show a snackbar when the character is created.
/// 
/// The class uses the CachedNetworkImage package to load the character images from the server.
/// It displays a placeholder image if the image is not available.
/// 
/// The class uses the SvgPicture widget to display the back button and theme toggle icon.
/// 
/// The class uses the Theme.of(context) to access the theme of the app.
/// It uses the theme colors and text styles to style the UI elements.
/// 
/// 
class CharacterListScreen extends StatelessWidget {
  final int universeId;

  const CharacterListScreen({super.key, required this.universeId});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final theme = Theme.of(context);

    Future<void> createCharacter(CharacterProvider characterProvider) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final success = await characterProvider.createCharacter(universeId, nameController.text);
      if (!context.mounted) return;
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character created')),
        );
        nameController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create character')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              'Characters',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: FutureBuilder(
        future: Provider.of<CharacterProvider>(context, listen: false).fetchCharacters(universeId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<CharacterProvider>(
              builder: (ctx, characterProvider, child) {
                final sortedCharacters = characterProvider.characters..sort((a, b) => a.name.compareTo(b.name));

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: theme.colorScheme.background,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/universe.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(theme.iconTheme.color ?? AppColor.hGrey, BlendMode.srcIn),
                                  ),
                                ),
                                hintText: 'Character name',
                                hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color ?? AppColor.hGrey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: theme.colorScheme.background),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: theme.colorScheme.background),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: theme.textTheme.bodyMedium?.color ?? AppColor.hGrey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => createCharacter(characterProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              textStyle: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text('Create', style: TextStyle(color: theme.colorScheme.primary)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: sortedCharacters.length,
                        itemBuilder: (ctx, i) {
                          final character = sortedCharacters[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/character_detail', arguments: character);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: theme.appBarTheme.backgroundColor ?? AppColor.hGreyLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                                        height: 150,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => SvgPicture.asset(
                                          'assets/icons/placeholder.svg',
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                          child: Text(
                                            character.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: theme.textTheme.bodyMedium?.color ?? AppColor.hBlack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}