// lib/screens/character_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/character_provider.dart';

class CharacterListScreen extends StatelessWidget {
  final int universeId;

  const CharacterListScreen({super.key, required this.universeId});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: FutureBuilder(
        future: Provider.of<CharacterProvider>(context, listen: false).fetchCharacters(universeId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<CharacterProvider>(
              builder: (ctx, characterProvider, child) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Create a new character'),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Character Name'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await characterProvider.createCharacter(
                                universeId,
                                nameController.text,
                              );
                              if (!context.mounted) return;
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
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: characterProvider.characters.length,
                        itemBuilder: (ctx, i) {
                          final character = characterProvider.characters[i];
                          return ListTile(
                            leading: character.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                : null,
                            title: Text(character.name),
                            onTap: () {
                              Navigator.of(context).pushNamed('/character_detail', arguments: character);
                            },
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